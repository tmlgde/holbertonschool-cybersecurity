#!/usr/bin/env python3
"""Logique de scan réseau de NetProbe (sockets TCP/UDP)."""
import random
import socket
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from typing import Optional

import utils


def check_port(ip: str, port: int) -> bool:
    """Vérifie si un port TCP est ouvert sur une cible.

    Args:
        ip: adresse IP ou nom d'hôte de la cible.
        port: numéro du port à tester.

    Returns:
        True si la connexion réussit, False sinon.
    """
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.settimeout(1.0)
            if utils.SOURCE_IP is not None:
                s.bind((utils.SOURCE_IP, 0))
            s.connect((ip, port))
            return True
    except OSError:
        return False


def get_banner(ip: str, port: int) -> str:
    """Récupère le banner du service sur un port ouvert.

    Args:
        ip: adresse IP ou nom d'hôte de la cible.
        port: numéro du port à interroger.

    Returns:
        Le banner nettoyé, la version du serveur HTTP, ou "Unknown".
    """
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.settimeout(1.0)
            if utils.SOURCE_IP is not None:
                s.bind((utils.SOURCE_IP, 0))
            s.connect((ip, port))
            s.sendall(f"GET / HTTP/1.1\r\nHost: {ip}\r\n\r\n".encode())
            banner_data = s.recv(1024)

            if banner_data == b"":
                return "Unknown"
            banner = banner_data.decode("utf-8", errors="ignore").strip()

            if banner.startswith("HTTP/"):
                return parse_http_server(banner)
            return banner
    except OSError:
        return "Unknown"


def parse_http_server(response: str) -> str:
    """Extrait la valeur de l'en-tête Server d'une réponse HTTP.

    Args:
        response: la réponse HTTP brute.

    Returns:
        La valeur de l'en-tête Server, ou "Unknown" s'il est absent.
    """
    lines = response.split("\n")
    for line in lines:
        if line.lower().startswith("server:"):
            return line.split(":", 1)[1].strip()
    return "Unknown"


def guess_service(port: int) -> str:
    """Devine le service d'un port à partir de son numéro.

    Args:
        port: numéro du port à identifier.

    Returns:
        Le service suivi de " (Guessed)", ou "Unknown".
    """
    common_ports = {
        21: "FTP",
        22: "SSH",
        80: "HTTP",
        443: "HTTPS",
        3306: "MySQL",
    }
    service_name = common_ports.get(port, "Unknown")
    if service_name == "Unknown":
        return "Unknown"
    return f"{service_name} (Guessed)"


def get_service_info(ip: str, port: int) -> str:
    """Identifie le service d'un port, par banner ou par déduction.

    Args:
        ip: adresse IP ou nom d'hôte de la cible.
        port: numéro du port à identifier.

    Returns:
        Le banner, le service deviné, ou "Unknown".
    """
    banner = get_banner(ip, port)

    if banner == "Unknown":
        return guess_service(port)
    return banner


def check_vulnerability(banner: str) -> str:
    """Compare un banner à une liste de versions vulnérables connues.

    Args:
        banner: le banner ou nom du service détecté.

    Returns:
        "[VULNERABLE]" si une signature connue est trouvée, "" sinon.
    """
    bad_signatures = ["vsftpd 2.3.4", "Apache 2.2.8"]

    for signature in bad_signatures:
        if signature.lower() in banner.lower():
            return "[VULNERABLE]"
    return ""


def scan_single_port(ip: str, port: int) -> Optional[dict]:
    """Teste un port, identifie son service et sa vulnérabilité.

    Args:
        ip: adresse IP ou nom d'hôte de la cible.
        port: numéro du port à tester.

    Returns:
        Un dictionnaire décrivant le port ouvert, ou None.
    """
    if check_port(ip, port):
        service = get_service_info(ip, port)
        status = check_vulnerability(service)

        line = f"[+] Port {port} Open: {service}"
        if status:
            line += f" {status}"
        print(line)

        return {'port': port, 'service': service,
                'vulnerability': "YES" if status else "NO",
                'state': 'open'}
    return None


def scan_ports(ip: str, start_port: int, end_port: int) -> list:
    """Scanne une plage de ports en parallèle (50 threads maximum).

    Args:
        ip: adresse IP ou nom d'hôte de la cible.
        start_port: premier port de la plage (inclus).
        end_port: dernier port de la plage (inclus).

    Returns:
        La liste des dictionnaires des ports ouverts.
    """
    print(f"Scanning {ip} from {start_port} to {end_port}...")
    results = []
    ports = list(range(start_port, end_port + 1))
    if utils.RANDOM_SCAN:
        random.shuffle(ports)
        print("Scanning ports randomly...")

    with ThreadPoolExecutor(max_workers=50) as executor:
        futures = []
        for port in ports:
            if utils.SCAN_DELAY > 0:
                print(f"[DEBUG] Sleeping {utils.SCAN_DELAY}s "
                      "before next packet...")
                time.sleep(utils.SCAN_DELAY)
            futures.append(executor.submit(scan_single_port, ip, port))
        for future in as_completed(futures):
            port_result = future.result()
            if port_result is not None:
                results.append(port_result)
    if not utils.RANDOM_SCAN:
        results.sort(key=lambda result: result['port'])
    return results


def scan_udp(ip: str, port: int) -> bool:
    """Scanne un port UDP (résultat Open/Filtered).

    Args:
        ip: adresse IP ou nom d'hôte de la cible.
        port: numéro du port UDP à tester.

    Returns:
        True si une réponse arrive ou en cas de timeout (Open/Filtered),
        False si le port est fermé (ICMP Unreachable).
    """
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as s:
            s.settimeout(1.0)
            if utils.SOURCE_IP is not None:
                s.bind((utils.SOURCE_IP, 0))
            s.sendto(b"", (ip, port))
            s.recvfrom(1024)
            return True
    except TimeoutError:
        return True
    except ConnectionRefusedError:
        return False
    except OSError:
        return False


def ping_sweep(subnet: str) -> list:
    """Cherche les hôtes actifs d'un sous-réseau /24 via le port 80.

    Args:
        subnet: les trois premiers octets, ex. "192.168.1".

    Returns:
        La liste des IP dont le port 80 est ouvert.
    """
    live_hosts = []

    for host_number in range(1, 255):
        ip = f"{subnet}.{host_number}"
        if check_port(ip, 80):
            live_hosts.append(ip)
    return live_hosts

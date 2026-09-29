#!/usr/bin/env python3
"""Debut du module, docstring a modifier"""
import socket
from concurrent.futures import ThreadPoolExecutor, as_completed
from typing import Optional


def main() -> None:
    """Print pour l'instant le message d'initialisation"""
    print("NetProbe v1.0 initialized...")
    scan_ports("127.0.0.1", 20, 80)


def check_port(ip: str, port: int) -> bool:
    """check l'ouverture de ports"""
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.settimeout(1.0)

        try:
            s.connect((ip, port))
            return True
        except OSError:
            return False


def ping_sweep(subnet: str) -> list:
    """test le sous réseau pour /24 sous réseau"""
    good_ip = []

    for i in range(1, 255):
        ip = f"{subnet}.{i}"
        if check_port(ip, 80):
            good_ip.append(ip)
    return good_ip


def get_banner(ip: str, port: int) -> str:
    """identifier le service lancé sur  un port ouvert"""
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.settimeout(1.0)
            s.connect((ip, port))
            s.sendall(b"HEAD / HTTP/1.0\r\n\r\n")
            banner_data = s.recv(1024)

            if banner_data == b"":
                return "Unknown"
            return banner_data.decode("utf-8", errors="ignore").strip()
    except OSError:
        return "Unknown"


def scan_ports(ip: str, start_port: int, end_port: int) -> list:
    """scan les ports avec un scan multi-threadé, 50 workers max"""
    print(f"Scanning {ip} from {start_port} to {end_port}...")
    results = []

    with ThreadPoolExecutor(max_workers=50) as executor:
        futures = []
        for port in range(start_port, end_port + 1):
            futures.append(executor.submit(scan_single_port, ip, port))
        for future in as_completed(futures):
            port_result = future.result()
            if port_result is not None:
                results.append(port_result)
    results.sort(key=lambda result: result['port'])
    return results


def scan_single_port(ip: str, port: int) -> Optional[dict]:
    """scan un port simple"""
    if check_port(ip, port):
        service = get_service_info(ip, port)
        status = check_vulnerablity(service)

        line = f"[+] Port {port} Open: {service}"
        if status:
            line += f" {status}"
            print(line)

        return {'port': port, 'service': service, 'vulnerabilty': status}
    return None


def guess_service(port: int) -> str:
    """identifier les services sans banner"""
    common_ports = {
                21: "FTP",
                22: "SSH",
                80: "HTTP",
                443: "HTTPS",
                3306: "MySQL"
                }
    service_name = common_ports.get(port, "Unknown")
    if service_name == "Unknown":
        return "Unknown"
    return f"{service_name} (Guessed)"


def get_service_info(ip: str, port: int) -> str:
    """indentifier le service d'un port avec banner"""
    banner = get_banner(ip, port)

    if banner == "Unknown":
        return "Unknown"
    return banner


def check_vulnerability(banner: str) -> str:
    """identifie une vulnerabilité dans une liste"""
    bad_signatures = ["vsftpd 2.3.4", "Apache 2.2.8"]

    for signature in bad_signatures:
        if signature.lower() in banner.lower():
            return "[VULNERABLE]"
    return ""


if __name__ == "__main__":
    main()

#!/usr/bin/env python3
"""Debut du module, docstring a modifier"""
import argparse
import json
import random
import socket
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from typing import Optional


RANDOM_SCAN = False
SCAN_DELAY = 0.0
SOURCE_IP = None


def main() -> None:
    """Print pour l'instant le message d'initialisation"""
    global SCAN_DELAY, RANDOM_SCAN, SOURCE_IP
    parser = argparse.ArgumentParser(
        description="NetProbe - TCP port scanner with banner grabbing"
    )
    parser.add_argument("-t", "--target", required=True,
                        help="Target IP address")
    parser.add_argument("-p", "--ports", default="1-1024",
                        help="Port range, e.g. 1-1000 (default: 1-1024)")
    parser.add_argument("-o", "--output", help="Output JSON file")
    parser.add_argument("-d", "--delay", type=float,
                        default=0.0, help="Delay between scans in second")
    parser.add_argument("-r", "--random", action="store_true",
                        help="Scan port in random order")
    parser.add_argument("-i", "--interface", help="Source ip to scan from")
    args = parser.parse_args()
    RANDOM_SCAN = args.random
    SCAN_DELAY = args.delay
    SOURCE_IP = args.interface

    print("NetProbe v1.0 initialized...")
    print(f"Target: {args.target} ({resolve_hostname(args.target)})")
    if args.interface is not None:
        print(f"[INFO] Scanning from source IP: {args.interface}")

    try:
        start_port, end_port = parse_port_range(args.ports)
    except ValueError:
        print("[ERROR] Invalid port range. "
              "Use format start-end (e.g. 1-1000).")
        return

    try:
        results = scan_ports(args.target, start_port, end_port)
    except KeyboardInterrupt:
        print("\n[INFO] Scan interrupted by user.")
        return

    if args.output is not None:
        save_report(results, args.output)


def check_port(ip: str, port: int) -> bool:
    """check l'ouverture de ports"""
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.settimeout(1.0)
            if SOURCE_IP is not None:
                s.bind((SOURCE_IP, 0))

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
            if SOURCE_IP is not None:
                s.bind((SOURCE_IP, 0))
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
    ports = list(range(start_port, end_port + 1))
    if RANDOM_SCAN:
        random.shuffle(ports)
        print("Scanning ports randomly...")

    with ThreadPoolExecutor(max_workers=50) as executor:
        futures = []
        for port in ports:
            if SCAN_DELAY > 0:
                print(f"[DEBUG] Sleeping {SCAN_DELAY}s before next packet...")
                time.sleep(SCAN_DELAY)
            futures.append(executor.submit(scan_single_port, ip, port))
        for future in as_completed(futures):
            port_result = future.result()
            if port_result is not None:
                results.append(port_result)
    if not RANDOM_SCAN:
        results.sort(key=lambda result: result['port'])
    return results


def scan_single_port(ip: str, port: int) -> Optional[dict]:
    """scan un port simple"""
    if check_port(ip, port):
        service = get_service_info(ip, port)
        status = check_vulnerability(service)

        line = f"[+] Port {port} Open: {service}"
        if status:
            line += f" {status}"
        print(line)

        return {'port': port, 'service': service,
                'vulnerability': "YES" if status else "NO", 'state': 'open'}
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
        return guess_service(port)
    return banner


def check_vulnerability(banner: str) -> str:
    """identifie une vulnerabilité dans une liste"""
    bad_signatures = ["vsftpd 2.3.4", "Apache 2.2.8"]

    for signature in bad_signatures:
        if signature.lower() in banner.lower():
            return "[VULNERABLE]"
    return ""


def parse_port_range(port_range: str) -> tuple:
    """docstring parse_port_range"""
    split_range = port_range.split("-")
    start_port, end_port = split_range
    return int(start_port), int(end_port)


def save_report(results: list, output_file: str) -> None:
    """docstring"""
    try:
        with open(output_file, "w", encoding="utf-8") as json_file:
            json.dump(results, json_file, indent=2)
            print(f"[+] Report saved to {output_file}")
    except OSError:
        print(f"[ERROR] Could not write report to {output_file}.")


def scan_udp(ip: str, port: int) -> bool:
    """scan de port udp, true renvoie une reponse, false est fermé"""
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as s:
            s.settimeout(1.0)
            if SOURCE_IP is not None:
                s.bind((SOURCE_IP, 0))
            s.sendto(b"", (ip, port))
            s.recvfrom(1024)
            return True
    except TimeoutError:
        return True
    except ConnectionRefusedError:
        return False
    except OSError:
        return False


def resolve_hostname(ip: str) -> str:
    """recuper le host name depuis ip"""
    try:
        hostname, aliases, addresses = socket.gethostbyaddr(ip)
        return hostname
    except OSError:
        return "Unknown"


if __name__ == "__main__":
    main()

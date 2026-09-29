#!/usr/bin/env python3
"""Debut du module, docstring a modifier"""
import socket


def main() -> None:
    """Print pour l'instant le message d'initialisation"""
    print("NetProbe v1.0 initialized...")
    print(ping_sweep("192.168.1"))
    print(get_banner("scanme.nmap.org", 22))


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
            try:
                banner_data = s.recv(1024)
            except TimeoutError:
                s.sendall(b"HEAD / HTTP/1.0\r\n\r\n")
                banner_data = s.recv(1024)

            if banner_data == b"":
                return "Unknown"
            return banner_data.decode("utf-8", errors="ignore").strip()
    except OSError:
        return "Unknown"


if __name__ == "__main__":
    main()

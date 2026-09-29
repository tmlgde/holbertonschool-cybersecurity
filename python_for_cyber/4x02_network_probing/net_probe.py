#!/usr/bin/env python3
"""Debut du module, docstring a modifier"""
import socket


def main() -> None:
    """Print pour l'instant le message d'initialisation"""
    print("NetProbe v1.0 initialized...")
    print(f"Port 80 is open: {check_port('google.com', 80)}")
    print(f"Port 81 is open: {check_port('google.com', 81)}")


def check_port(ip: str, port: int) -> bool:
    """check l'ouverture de ports"""
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.settimeout(1.0)

        try:
            s.connect((ip, port))
            return True
        except OSError:
            return False


if __name__ == "__main__":
    main()

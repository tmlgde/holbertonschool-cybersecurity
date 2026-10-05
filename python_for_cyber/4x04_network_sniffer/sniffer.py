#!/usr/bin/env python3
"""Création d'un outil qui marche comme Wireshark"""

from scapy.all import sniff


def main() -> None:
    """Fonction main du projet"""
    sniff(count=5, prn=packet_handler)


def packet_handler(packet) -> None:
    """Print une seule ligne pour packet.summary"""
    print(packet.summary())


if __name__ == "__main__":
    main()

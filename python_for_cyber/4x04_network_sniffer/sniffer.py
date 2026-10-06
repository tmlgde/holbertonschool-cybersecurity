#!/usr/bin/env python3
"""Création d'un outil qui marche comme Wireshark"""

import argparse
from scapy.all import sniff


def main() -> None:
    """Fonction main du projet. Capture le message d'erreur avec un print"""

    parser = argparse.ArgumentParser(description="Sniffer")
    parser.add_argument("-f", "--filter", help="Filter from packet")
    parser.add_argument("-i", "--interface", help="Interface to sniff")
    args = parser.parse_args()
    try:
        sniff(iface=args.interface, filter=args.filter,
              prn=packet_handler, chainCC=True)
    except KeyboardInterrupt:
        print("[INFO] Stopping capture...")
    except ValueError as error:
        print(f"[ERROR] Invalid interface: {error}")
    except Exception as error:
        print(f"[ERROR] Capture failed: {error}")


def packet_handler(packet) -> None:
    """Print une seule ligne pour packet.summary"""
    from scapy.all import IP, TCP, UDP, ICMP
    if packet.haslayer(IP):
        ip_src = packet[IP].src
        ip_dst = packet[IP].dst
        if packet.haslayer(TCP):
            tcp_flags = packet[TCP].flags
            src_port = packet[TCP].sport
            dst_port = packet[TCP].dport
            print(f"[TCP] {ip_src}:{src_port} -> {ip_dst}:{dst_port}"
                  f" | Flags: {tcp_flags}")
        elif packet.haslayer(UDP):
            print(f"[UDP] {ip_src} -> {ip_dst}")
        elif packet.haslayer(ICMP):
            print(f"[ICMP] {ip_src} -> {ip_dst}")


if __name__ == "__main__":
    main()

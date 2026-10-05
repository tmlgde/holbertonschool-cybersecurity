#!/usr/bin/env python3
"""Création d'un outil qui marche comme Wireshark"""

from scapy.all import sniff, IP, TCP, UDP, ICMP


def main() -> None:
    """Fonction main du projet"""
    sniff(count=5, prn=packet_handler)


def packet_handler(packet) -> None:
    """Print une seule ligne pour packet.summary"""
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

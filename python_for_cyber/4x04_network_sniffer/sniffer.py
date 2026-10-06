#!/usr/bin/env python3
"""Création d'un outil qui marche comme Wireshark"""

import argparse
import scapy.all as scapy_all
from scapy.all import sniff


class Sniffer:
    """classe sniffer qui regroupe tout le code"""

    def __init__(self, interface, filter_str, output_file, verbose=False):
        """fonction constructeur"""
        self.filter_str = filter_str
        self.interface = interface
        self.output_file = output_file
        self.verbose = verbose

    def start(self) -> None:
        """fonction main déplacée"""
        try:
            sniff(iface=self.interface, filter=self.filter_str,
                  prn=self._process_packet, chainCC=True)
        except KeyboardInterrupt:
            print("[INFO] Stopping capture...")
        except ValueError as error:
            print(f"[ERROR] Invalid interface: {error}")
        except Exception as error:
            print(f"[ERROR] Capture failed: {error}")

    def _process_packet(self, packet) -> None:
        """Print une seule ligne pour packet.summary"""
        if self.output_file is not None:
            try:
                scapy_all.wrpcap(self.output_file, packet, append=True)
            except OSError as error:
                print(f"[ERROR] Cannot write to output file: {error}")
        try:
            if packet.haslayer(scapy_all.IP):
                ip_src = packet[scapy_all.IP].src
                ip_dst = packet[scapy_all.IP].dst
                if packet.haslayer(scapy_all.TCP):
                    tcp_flags = getattr(packet[scapy_all.TCP],
                                        "flags", "")
                    src_port = packet[scapy_all.TCP].sport
                    dst_port = packet[scapy_all.TCP].dport
                    print(f"[TCP] {ip_src}:{src_port} -> {ip_dst}:{dst_port}"
                          f" | Flags: {tcp_flags}")
                elif packet.haslayer(scapy_all.UDP):
                    print(f"[UDP] {ip_src} -> {ip_dst}")
                elif packet.haslayer(scapy_all.ICMP):
                    print(f"[ICMP] {ip_src} -> {ip_dst}")
        finally:
            if self.verbose:
                scapy_all.hexdump(packet)


def main() -> None:
    """Fonction main du projet. Capture le message d'erreur avec un print"""

    parser = argparse.ArgumentParser(description="Sniffer")
    parser.add_argument("-f", "--filter", help="Filter from packet")
    parser.add_argument("-i", "--interface", help="Interface to sniff")
    parser.add_argument("-w", "--write",
                        help="File .pcap for save packets")
    parser.add_argument("-v", "--verbose", action="store_true",
                        help="Print the hexdump of each packet")
    args = parser.parse_args()
    sniffer = Sniffer(args.interface, args.filter, args.write, args.verbose)
    sniffer.start()


if __name__ == "__main__":
    main()

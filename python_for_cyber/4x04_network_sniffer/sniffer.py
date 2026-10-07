#!/usr/bin/env python3
"""Création d'un outil qui marche comme Wireshark"""

import argparse
import scapy.all as scapy_all
from scapy.all import sniff
import queue
import threading


class Sniffer:
    """classe sniffer qui regroupe tout le code"""

    def __init__(self, interface, filter_str, output_file, verbose=False,
                 search=None):
        """fonction constructeur"""
        self.filter_str = filter_str
        self.interface = interface
        self.output_file = output_file
        self.verbose = verbose
        self.processors = [TCPProcessor(), UDPProcessor(), ICMPProcessor()]
        self.search = search
        self.stats = {'TCP': 0, 'UDP': 0, 'ICMP': 0}
        self.packet_queue = queue.Queue()

    def start(self) -> None:
        """fonction main déplacée"""
        worker = threading.Thread(target=self._worker)
        worker.start()
        interrupted = False
        try:
            sniff(iface=self.interface, filter=self.filter_str,
                  prn=self._enqueue_packet, chainCC=True)
        except KeyboardInterrupt:
            interrupted = True
        except ValueError as error:
            print(f"[ERROR] Invalid interface: {error}")
        except Exception as error:
            print(f"[ERROR] Capture failed: {error}")
        finally:
            self.packet_queue.put(None)
            worker.join()
        if interrupted:
            print("[INFO] Stopping capture...")
            self._print_stats()

    def _process_packet(self, packet) -> None:
        """Print une seule ligne pour packet.summary"""
        if self.output_file is not None:
            try:
                scapy_all.wrpcap(self.output_file, packet, append=True)
            except OSError as error:
                print(f"[ERROR] Cannot write to output file: {error}")
        try:
            if packet.haslayer(scapy_all.IP):
                for processor in self.processors:
                    if processor.matches(packet):
                        self.stats[processor.name] += 1
                        processor.process(packet)
                        break
        finally:
            self._search_payload(packet)
            if self.verbose:
                scapy_all.hexdump(packet)

    def _print_stats(self) -> None:
        """print le resultat en parcourant le dict"""
        for protocol, count in self.stats.items():
            print(f"{protocol}: {count}")

    def _search_payload(self, packet) -> None:
        """Verifie la couche Raw"""
        if self.search is None:
            return
        if not packet.haslayer(scapy_all.Raw):
            return
        payload = getattr(packet[scapy_all.Raw], "load", b"")
        if isinstance(payload, bytes):
            payload = payload.decode("utf-8", errors="ignore")
        if self.search in payload:
            print("[ALERT] Payload Match found!")

    def _enqueue_packet(self, packet) -> None:
        """prend un paquet et le pose dans la file"""
        self.packet_queue.put(packet)

    def _worker(self) -> None:
        """traite les paquets en boucle"""
        while True:
            packet = self.packet_queue.get()
            if packet is None:
                break
            try:
                self._process_packet(packet)
            except Exception as error:
                print(f"[ERROR] Packet processing failed: {error}")


class PacketProcessor:
    """CLasse de base pour traiter un type de paquet"""

    def matches(self, packet) -> bool:
        """Indique si ce processeur gère ce paquet"""
        raise NotImplementedError

    def process(self, packet) -> None:
        """Affiche la ligne du résumé du paquet"""
        raise NotImplementedError


class TCPProcessor(PacketProcessor):
    """Traite les paquets TCP"""

    name = "TCP"

    def matches(self, packet) -> bool:
        """Renvoie True si le paquet contient tcp"""
        return packet.haslayer(scapy_all.TCP)

    def process(self, packet) -> None:
        """Affiche "[TCP] SRC:PORT -> DST:PORT | Flags: X"."""
        ip_src = packet[scapy_all.IP].src
        ip_dst = packet[scapy_all.IP].dst
        tcp_flags = getattr(packet[scapy_all.TCP], "flags", "")
        src_port = getattr(packet[scapy_all.TCP], "sport", "")
        dst_port = getattr(packet[scapy_all.TCP], "dport", "")
        print(f"[TCP] {ip_src}:{src_port} -> {ip_dst}:{dst_port}"
              f" | Flags: {tcp_flags}")


class UDPProcessor(PacketProcessor):
    """Traites les paquets UDP"""

    name = "UDP"

    def matches(self, packet) -> bool:
        """Renvoie true si le paquet contient UDP"""
        return packet.haslayer(scapy_all.UDP)

    def process(self, packet) -> None:
        """Affiche les lignes UDP"""
        ip_src = packet[scapy_all.IP].src
        ip_dst = packet[scapy_all.IP].dst
        print(f"[UDP] {ip_src} -> {ip_dst}")


class ICMPProcessor(PacketProcessor):
    """Traite les données ICMP"""

    name = "ICMP"

    def matches(self, packet) -> bool:
        """Renvoie True si le paquet contient ICMP"""
        return packet.haslayer(scapy_all.ICMP)

    def process(self, packet) -> None:
        """Affiche les lignes ICMP"""
        ip_src = packet[scapy_all.IP].src
        ip_dst = packet[scapy_all.IP].dst
        print(f"[ICMP] {ip_src} -> {ip_dst}")


def main() -> None:
    """Fonction main du projet. Capture le message d'erreur avec un print"""

    parser = argparse.ArgumentParser(description="Sniffer")
    parser.add_argument("-f", "--filter", help="Filter from packet")
    parser.add_argument("-i", "--interface", help="Interface to sniff")
    parser.add_argument("-w", "--write",
                        help="File .pcap for save packets")
    parser.add_argument("-v", "--verbose", action="store_true",
                        help="Print the hexdump of each packet")
    parser.add_argument("-s", "--search", help="Search raw for DPI")
    args = parser.parse_args()
    sniffer = Sniffer(args.interface, args.filter, args.write, args.verbose,
                      args.search)
    sniffer.start()


if __name__ == "__main__":
    main()

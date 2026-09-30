#!/usr/bin/env python3
"""NetProbe : point d'entrée en ligne de commande.

Scanner réseau TCP/UDP avec banner grabbing, détection de
vulnérabilités, scan furtif et export JSON.
"""
import argparse

import reporter
import scanner
import utils


def main() -> None:
    """Lit les arguments, lance le scan et écrit le rapport.

    Ne renvoie rien.
    """
    parser = argparse.ArgumentParser(
        description="NetProbe - TCP port scanner with banner grabbing"
    )
    parser.add_argument("-t", "--target", required=True,
                        help="Target IP address")
    parser.add_argument("-p", "--ports", default="1-1024",
                        help="Port range, e.g. 1-1000 (default: 1-1024)")
    parser.add_argument("-o", "--output", help="Output JSON file")
    parser.add_argument("-d", "--delay", type=float,
                        default=0.0, help="Delay between scans in seconds")
    parser.add_argument("-r", "--random", action="store_true",
                        help="Scan ports in random order")
    parser.add_argument("-i", "--interface",
                        help="Source IP address to scan from")
    args = parser.parse_args()

    utils.SCAN_DELAY = args.delay
    utils.RANDOM_SCAN = args.random
    utils.SOURCE_IP = args.interface

    print("NetProbe v1.0 initialized...")
    print(f"Target: {args.target} "
          f"({utils.resolve_hostname(args.target)})")
    if args.interface is not None:
        print(f"[INFO] Scanning from source IP: {args.interface}")

    try:
        start_port, end_port = utils.parse_port_range(args.ports)
    except ValueError:
        print("[ERROR] Invalid port range. "
              "Use format start-end (e.g. 1-1000).")
        return

    try:
        results = scanner.scan_ports(args.target, start_port, end_port)
    except KeyboardInterrupt:
        print("\n[INFO] Scan interrupted by user.")
        return

    if args.output is not None:
        reporter.save_report(results, args.output)


if __name__ == "__main__":
    main()

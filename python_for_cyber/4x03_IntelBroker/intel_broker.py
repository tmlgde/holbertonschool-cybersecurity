#!/usr/bin/env python3
"""IntelBroker : point d'entrée de l'outil de reconnaissance."""
import argparse
import asyncio

from api_client import fetch_api, gather_intel
from api_client import query_abuseipdb, query_virustotal
from models import TargetDossier
from scanner import parse_nmap_xml, run_nmap
from utils import get_intel, load_cache, save_cache


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="IntelBroker")
    parser.add_argument("ip", help="IP address to investigate")
    parser.add_argument("-o", "--output", help="Save report to JSON file")
    parser.add_argument("-v", "--verbose", action="store_true",
                        help="Print action from IntelBroker")
    args = parser.parse_args()

    dossier = TargetDossier(args.ip)
    if args.verbose:
        print("[+] Querying VirusTotal...")
    results = get_intel(dossier.ip)
    dossier.vt_data, dossier.abuse_data, dossier.shodan_data = results
    try:
        xml_data = asyncio.run(run_nmap(dossier.ip))
        dossier.nmap_ports = parse_nmap_xml(xml_data)
        if args.verbose:
            print("[+] Nmap finished.")
    except (RuntimeError, FileNotFoundError):
        print("[ERROR] Nmap scan failed.")
    dossier.print_summary()
    if args.output:
        dossier.save_json(args.output)
        if args.verbose:
            print("[SUCCESS] Report generated.")

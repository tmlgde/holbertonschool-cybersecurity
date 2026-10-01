#!/usr/bin/env python3
"""IntelBroker : interroge des API de Threat Intelligence simulées."""
import aiohttp
import argparse
import asyncio
import json
import requests
import xml.etree.ElementTree as ET

from datetime import datetime


class TargetDossier:
    """regroupe les infos collectées"""
    def __init__(self, ip: str = "", vt_data: dict = None,
                 abuse_data: dict = None,
                 nmap_ports: list = None, shodan_data: dict = None) -> None:
        """def init"""
        self.ip = ip
        self.vt_data = vt_data or {}
        self.abuse_data = abuse_data or {}
        self.nmap_ports = nmap_ports or []
        self.shodan_data = shodan_data or {}

    def print_summary(self) -> None:
        """Affiche un résumé du dossier."""
        print(f"Target: {self.ip}")
        print(f"VirusTotal: {self.vt_data}")
        print(f"AbuseIPDB: {self.abuse_data}")
        print(f"Open ports: {self.nmap_ports}")

    def to_dict(self) -> dict:
        """Renvoie le dossier au format du rapport JSON."""
        return {
            "target": self.ip,
            "timestamp": datetime.now().isoformat(),
            "intelligence": {
                "virustotal": self.vt_data,
                "abuseipdb": self.abuse_data,
                "shodan": self.shodan_data,
                "nmap": self.nmap_ports,
            },
        }

    def save_json(self, path: str) -> None:
        """Enregistre le dossier dans un fichier JSON"""
        try:
            with open(path, "w") as f:
                json.dump(self.to_dict(), f, indent=4)
            print(f"[+] Report saved to {path}")
        except OSError:
            print("[ERROR] Cannot write the report file.")


def query_virustotal(ip: str) -> dict:
    """Interroge VirusTotal (mock) sur une IP.

    Entrée : l'adresse IP à analyser.
    Sortie : la réponse JSON sous forme de dict, ou {} en cas d'erreur.
    """
    url = f"http://localhost:5000/virustotal/{ip}"
    try:
        response = requests.get(url)
        if response.status_code == 200:
            return response.json()
        print("[ERROR] Unexpected status code.")
    except requests.exceptions.ConnectionError:
        print("[ERROR] Cannot reach the API server.")
    return {}


def query_abuseipdb(ip: str) -> dict:
    """Interroge abuseipdb"""
    url = f"http://localhost:5000/abuseipdb/{ip}"
    try:
        response = requests.get(url)
        if response.status_code == 200:
            return response.json()
        print("[ERROR] Unexpected status code.")
    except requests.exceptions.ConnectionError:
        print("[ERROR] Cannot reach the API server.")
    return {}


def parse_nmap_xml(xml_data: str) -> list:
    """Extrait les ports ouverts d'une sortie XML de Nmap."""
    open_ports = []
    root = ET.fromstring(xml_data)
    for port in root.findall("host/ports/port"):
        if port.find("state").get("state") == "open":
            open_ports.append(int(port.get("portid")))
    return open_ports


async def fetch_api(session, url):
    try:
        async with session.get(url) as response:
            if response.status == 200:
                return await response.json()
            print("[ERROR] Unexpected status code.")
    except aiohttp.ClientConnectionError:
        print("[ERROR] Cannot reach the API server.")
    return {}


async def gather_intel(ip):
    """fonction asynchrone"""
    async with aiohttp.ClientSession() as session:
        url_vt = f"http://localhost:5000/virustotal/{ip}"
        url_ai = f"http://localhost:5000/abuseipdb/{ip}"
        url_sh = f"http://localhost:5000/shodan/{ip}"
        results = await asyncio.gather(
                fetch_api(session, url_vt),
                fetch_api(session, url_ai),
                fetch_api(session, url_sh),
                )
        return results


async def run_nmap(ip) -> str:
    """run nmap asynchone"""
    process = await asyncio.create_subprocess_exec(
            "nmap", "-p", "22,80", ip, "-oX", "-",
            stdout=asyncio.subprocess.PIPE
    )
    stdout, stderr = await process.communicate()
    if process.returncode != 0:
        raise RuntimeError("Nmap scan failed.")
    return stdout.decode()


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="IntelBroker")
    parser.add_argument("ip", help="IP address to investigate")
    parser.add_argument("-o", "--output", help="Save report to JSON file")
    args = parser.parse_args()

    dossier = TargetDossier(args.ip)
    results = asyncio.run(gather_intel(dossier.ip))
    dossier.vt_data, dossier.abuse_data, dossier.shodan_data = results
    try:
        xml_data = asyncio.run(run_nmap(dossier.ip))
        dossier.nmap_ports = parse_nmap_xml(xml_data)
    except (RuntimeError, FileNotFoundError):
        print("[ERROR] Nmap scan failed.")
    dossier.print_summary()
    if args.output:
        dossier.save_json(args.output)

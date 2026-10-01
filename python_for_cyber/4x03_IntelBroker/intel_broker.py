#!/usr/bin/env python3
"""IntelBroker : interroge des API de Threat Intelligence simulées."""
import requests
import subprocess
import xml.etree.ElementTree as ET


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


def run_nmap(ip: str) -> str:
    """verifie en direct les ports ouverts ou fermees avec nmap"""
    command = ["nmap", "-p", "22,80", ip, "-oX", "-"]
    resultat = subprocess.run(command, capture_output=True, text=True)
    if resultat.returncode != 0:
        raise RuntimeError("Nmap scan failed.")
    return resultat.stdout


def parse_nmap_xml(xml_data: str) -> list:
    """Extrait les ports ouverts d'une sortie XML de Nmap."""
    open_ports = []
    root = ET.fromstring(xml_data)
    for port in root.findall("host/ports/port"):
        if port.find("state").get("state") == "open":
            open_ports.append(int(port.get("portid")))
    return open_ports


if __name__ == "__main__":
    print(query_virustotal("1.2.3.4"))
    print(query_abuseipdb("1.2.3.4"))
    try:
        print(run_nmap("127.0.0.1"))
    except (RuntimeError, FileNotFoundError):
        print("[ERROR] Nmap scan failed.")
    print(parse_nmap_xml(run_nmap("127.0.0.1")))

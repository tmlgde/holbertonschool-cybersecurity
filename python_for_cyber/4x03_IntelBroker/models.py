#!/usr/bin/env python3
"""Modèle de données : le dossier de renseignement d'une cible."""
import json
from datetime import datetime


class TargetDossier:
    """Regroupe toutes les informations collectées sur une cible."""

    def __init__(self, ip: str = "", vt_data: dict = None,
                 abuse_data: dict = None, nmap_ports: list = None,
                 shodan_data: dict = None) -> None:
        """Crée le dossier d'une cible.

        Entrée : l'IP, et optionnellement les données VT, AbuseIPDB,
        Nmap et Shodan.
        """
        self.ip = ip
        self.vt_data = vt_data or {}
        self.abuse_data = abuse_data or {}
        self.nmap_ports = nmap_ports or []
        self.shodan_data = shodan_data or {}

    def print_summary(self) -> None:
        """Affiche un résumé du dossier."""
        print(f"Target: {self.ip}")
        print(f"VirusTotal: {self.vt_data.get('error', self.vt_data)}")
        print(f"AbuseIPDB: {self.abuse_data.get('error', self.abuse_data)}")
        print(f"Shodan: {self.shodan_data.get('error', self.shodan_data)}")
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
        """Enregistre le dossier dans un fichier JSON.

        Entrée : le chemin du fichier à créer.
        """
        try:
            with open(path, "w") as f:
                json.dump(self.to_dict(), f, indent=4)
            print(f"[+] Report saved to {path}")
        except OSError:
            print("[ERROR] Cannot write the report file.")

#!/usr/bin/env python3
"""IntelBroker : interroge des API de Threat Intelligence simulées."""
import requests


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


if __name__ == "__main__":
    print(query_virustotal("1.2.3.4"))
    print(query_abuseipdb("1.2.3.4"))

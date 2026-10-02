#!/usr/bin/env python3
"""Client HTTP : interroge les API de Threat Intelligence (mock)."""
import asyncio

import aiohttp
import requests


def query_virustotal(ip: str) -> dict:
    """Interroge VirusTotal (mock) sur une IP.

    Entrée : l'adresse IP à analyser.
    Sortie : la réponse JSON sous forme de dict,
    ou {"error": "Unavailable"} en cas d'erreur.
    """
    url = f"http://localhost:5000/virustotal/{ip}"
    try:
        response = requests.get(url)
        if response.status_code == 200:
            return response.json()
        print("[ERROR] Unexpected status code.")
    except requests.exceptions.RequestException:
        print("[ERROR] API unavailable.")
    return {"error": "Unavailable"}


def query_abuseipdb(ip: str) -> dict:
    """Interroge AbuseIPDB (mock) sur une IP.

    Entrée : l'adresse IP à analyser.
    Sortie : la réponse JSON sous forme de dict,
    ou {"error": "Unavailable"} en cas d'erreur.
    """
    url = f"http://localhost:5000/abuseipdb/{ip}"
    try:
        response = requests.get(url)
        if response.status_code == 200:
            return response.json()
        print("[ERROR] Unexpected status code.")
    except requests.exceptions.RequestException:
        print("[ERROR] API unavailable.")
    return {"error": "Unavailable"}


async def fetch_api(session: aiohttp.ClientSession, url: str) -> dict:
    """Interroge une API de façon asynchrone.

    Entrée : une session aiohttp et l'URL à interroger.
    Sortie : la réponse JSON sous forme de dict,
    ou {"error": "Unavailable"} si l'API échoue.
    """
    try:
        async with session.get(url) as response:
            if response.status == 200:
                return await response.json()
            print("[ERROR] Unexpected status code.")
    except Exception:
        print("[ERROR] API unavailable.")
    return {"error": "Unavailable"}


async def gather_intel(ip: str) -> list:
    """Interroge VirusTotal, AbuseIPDB et Shodan en parallèle.

    Entrée : l'adresse IP à analyser.
    Sortie : la liste des 3 réponses [vt, abuse, shodan].
    Au plus 5 requêtes tournent en même temps (sémaphore).
    """
    semaphore = asyncio.Semaphore(5)
    async with aiohttp.ClientSession() as session:

        async def limited_fetch(url: str) -> dict:
            """Interroge une API en respectant la limite du sémaphore."""
            async with semaphore:
                return await fetch_api(session, url)

        url_vt = f"http://localhost:5000/virustotal/{ip}"
        url_ai = f"http://localhost:5000/abuseipdb/{ip}"
        url_sh = f"http://localhost:5000/shodan/{ip}"
        results = await asyncio.gather(
            limited_fetch(url_vt),
            limited_fetch(url_ai),
            limited_fetch(url_sh),
        )
        return results

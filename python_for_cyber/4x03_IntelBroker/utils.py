#!/usr/bin/env python3
"""Utilitaires : cache JSON des réponses des API."""
import asyncio
import json
import time

from api_client import gather_intel


def load_cache() -> dict:
    """Lit le cache depuis cache.json.

    Sortie : le contenu du cache, ou {} si le fichier n'existe pas.
    """
    try:
        with open("cache.json", "r") as f:
            return json.load(f)
    except FileNotFoundError:
        return {}


def save_cache(cache: dict) -> None:
    """Enregistre le cache dans cache.json.

    Entrée : le dictionnaire du cache.
    """
    try:
        with open("cache.json", "w") as f:
            json.dump(cache, f, indent=4)
    except OSError:
        print("[ERROR] Cannot write the cache file.")


def get_intel(ip: str) -> list:
    """Renvoie les données des 3 API, en passant par le cache.

    Entrée : l'adresse IP à analyser.
    Sortie : la liste [vt, abuse, shodan], depuis le cache si elle
    a moins d'une heure, sinon depuis les API.
    """
    cache = load_cache()
    entry = cache.get(ip)
    if entry and time.time() - entry["timestamp"] < 3600:
        return entry["data"]
    data = asyncio.run(gather_intel(ip))
    cache[ip] = {"timestamp": time.time(), "data": data}
    save_cache(cache)
    return data

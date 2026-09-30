#!/usr/bin/env python3
"""Fonctions utilitaires et configuration partagée de NetProbe."""
import socket


SCAN_DELAY = 0.0
RANDOM_SCAN = False
SOURCE_IP = None


def parse_port_range(port_range: str) -> tuple:
    """Convertit une plage "début-fin" en tuple (start, end) d'entiers.

    Args:
        port_range: plage au format "1-1000".

    Returns:
        Un tuple (start_port, end_port).

    Raises:
        ValueError: si le format est invalide.
    """
    split_range = port_range.split("-")
    start_port, end_port = split_range
    return int(start_port), int(end_port)


def resolve_hostname(ip: str) -> str:
    """Résout le nom d'hôte (PTR) associé à une IP.

    Args:
        ip: adresse IP à résoudre.

    Returns:
        Le nom d'hôte, ou "Unknown" si aucun PTR n'existe.
    """
    try:
        hostname, _, _ = socket.gethostbyaddr(ip)
        return hostname
    except OSError:
        return "Unknown"

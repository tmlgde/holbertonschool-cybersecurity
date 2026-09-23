#!/usr/bin/env python3
import re
import hashlib


def clean_data(lines: list) -> list:
    """Nettoyer le fichier avant la recuperation"""
    cleaned = []
    for line in lines:
        stripped = line.strip()
        if not stripped:
            continue
        if stripped.startswith("#"):
            continue
        cleaned.append(stripped)
    return cleaned

def validate_line(line: str) -> bool:
    """utilisation d'une regex pour format mail:password"""
    pattern = r"^([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}):([^:]+)$"
    match = re.fullmatch(pattern, line)
    return match is not None

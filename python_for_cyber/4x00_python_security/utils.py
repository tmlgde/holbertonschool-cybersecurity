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

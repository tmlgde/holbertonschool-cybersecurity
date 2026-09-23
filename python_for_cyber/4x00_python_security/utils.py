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

def check_policy(password: str) -> str:
    """Verification de sécurité pour le mot de passe"""
    if len(password) < 8 or password.isalpha() or password in common_list:
        return "WEAK"
    else:
        return "COMPLIANT"

def hash_password(password: str, salt: str) -> str:
    """transforme les mots de passe weak en hash"""
    combined_bytes = password.encode() + salt.encode()
    hash_obj = hashlib.sha256(combined_bytes)
    hex_final = hash_obj.hexdigest()
    return hex_final

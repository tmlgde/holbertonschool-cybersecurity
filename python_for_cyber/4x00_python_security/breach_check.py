#!/usr/bin/env python3
import argparse
import sys
import re
import logging
import hashlib
import configparser
import os

logger = logging.getLogger()
logger.setLevel(logging.DEBUG)
formatter = logging.Formatter("%(asctime)s - %(levelname)s - %(message)s")
console_handler = logging.StreamHandler()
console_handler.setLevel(logging.INFO)
console_handler.setFormatter(formatter)
file_handler = logging.FileHandler("breach_check.log")
file_handler.setLevel(logging.DEBUG)
file_handler.setFormatter(formatter)
logger.addHandler(console_handler)
logger.addHandler(file_handler)

CONFIG_FILE = "config.ini"

if not os.path.exists(CONFIG_FILE):
    logging.error("[ERROR] Config file missing")
    sys.exit(1)

config = configparser.ConfigParser()
config.read(CONFIG_FILE)

common_list = ["password", "123456"]

def main(): 
    """Parse les arguments et demarre l'outil"""
    parser = argparse.ArgumentParser(description="BreachCheck!")
    parser.add_argument("-f", "--file", required=True, type=str, help="Path to the input file to analyze")
    parser.add_argument("-v","--verbose", action="store_true", help="Enable verbose output")
    parser.add_argument("-o","--output", help="path to the output report file")
    args = parser.parse_args()
    logging.info("BreachCheck v1.0 startup...")
    lines = read_file(args.file)

def read_file(filename: str) -> list:
    """Prend un fichier en entree et le lit comme une list"""
    try:
        with open(filename) as f:
            data = f.readlines()
        return data 
    except FileNotFoundError:
        logging.error(f"[ERROR] File not found: {filename}")
        sys.exit(1)
    except PermissionError:
        logging.error(f"[ERROR] Permission denied: {filename}")
        sys.exit(1)

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


if __name__ == "__main__":
    main()


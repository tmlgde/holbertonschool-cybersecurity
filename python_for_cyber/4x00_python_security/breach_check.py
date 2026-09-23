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
    logging.error("[ERROR] config file missing")
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

if __name__ == "__main__":
    main()


#!/usr/bin/env python3
import argparse
import sys
import re

def main(): 
    """Parse les arguments et demarre l'outil"""
    parser = argparse.ArgumentParser(description="BreachCheck!")
    parser.add_argument("-f", "--file", required=True, type=str, help="Path to the input file to analyze")
    parser.add_argument("-v","--verbose", action="store_true", help="Enable verbose output")
    parser.add_argument("-o","--output", help="path to the output report file")
    args = parser.parse_args()
    print("BreachCheck v1.0 startup...")
    lines = read_file(args.file)

def read_file(filename: str) -> list:
    """Prend un fichier en entree et le lit comme une list"""
    try:
        with open(filename) as f:
            data = f.readlines()
        return data 
    except FileNotFoundError:
        print(f"[ERROR] File not found: {filename}", file=sys.stderr)
        sys.exit(1)
    except PermissionError:
        print(f"[ERROR] Permission denied: {filename}", file=sys.stderr)
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


if __name__ == "__main__":
    main()


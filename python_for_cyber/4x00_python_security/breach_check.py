#!/usr/bin/env python3
import argparse
import sys

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


if __name__ == "__main__":
    main()


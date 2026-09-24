#!/usr/bin/env python3
"""création de LogHunter qui analyse un fichier de logs"""
import argparse
from typing import Iterator


def read_stream(file_path: str) -> Iterator[str]:
    """Lit le fichier ligne par ligne et yield"""
    try:
        with open(file_path, "r", encoding="utf-8",
                  errors="replace") as log_file:
            for line in log_file:
                yield line.rstrip("\n")
    except FileNotFoundError:
        print(f"[ERROR] File not found: {file_path}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="LogHunter - Log Analysis Engine")
    parser.add_argument("file", help="Path to the log file")
    args = parser.parse_args()

    print("[*] LogHunter - Log Analysis Engine")
    print(f"[*] Reading: {args.file}")

    line_count = 0
    for _ in read_stream(args.file):
        line_count += 1

    if line_count == 0:
        print("[!] No data to process. Exiting.")
    else:
        print(f"[*] Lines read: {line_count}")

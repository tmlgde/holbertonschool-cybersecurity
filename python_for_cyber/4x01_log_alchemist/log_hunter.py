#!/usr/bin/env python3
"""création de LogHunter qui analyse un fichier de logs"""
import argparse
import re
from typing import Iterator


APACHE_LINE_PATTERN = re.compile(
        r'^(?P<ip>[\d\.]+)\s\S+\s\S+\s'
        r'\[(?P<date>[^\]]+)\]\s'
        r'"(?P<method>[A-Z]+)\s(?P<path>[^"]+?)(?:\sHTTP/[\d\.]+)?"\s'
        r'(?P<status>\d{3})\s(?P<size>\d+|-)')


def read_stream(file_path: str) -> Iterator[str]:
    """Lit le fichier ligne par ligne et yield"""
    try:
        with open(file_path, "r", encoding="utf-8",
                  errors="replace") as log_file:
            for line in log_file:
                yield line.rstrip("\n")
    except FileNotFoundError:
        print(f"[ERROR] File not found: {file_path}")


def parse_apache_line(line: str) -> dict:
    """parse lignes logs APACHE et renvoie None si elle ne correspond pas"""
    match = APACHE_LINE_PATTERN.search(line)
    if not match:
        return None
    return match.groupdict()


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="LogHunter - Log Analysis Engine")
    parser.add_argument("file", help="Path to the log file")
    args = parser.parse_args()

    print("[*] LogHunter - Log Analysis Engine")
    print(f"[*] Reading: {args.file}")

    apache_line_count = 0
    syslog_line_count = 0
    for line in read_stream(args.file):
        event = parse_apache_line(line)
        if event is not None:
            apache_line_count += 1

    total_parsed = apache_line_count + syslog_line_count

    if total_parsed == 0:
        print("[!] No data to process. Exiting.")
    else:
        print("--- Parsing ---")
        print(f"[*] Apache lines:  {apache_line_count}")
        print(f"[*] Syslog lines:  {syslog_line_count}")
        print(f"[*] Total parsed:  {total_parsed}")

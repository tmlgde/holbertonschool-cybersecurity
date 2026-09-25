#!/usr/bin/env python3
"""création de LogHunter qui analyse un fichier de logs"""
import argparse
import re
from typing import Iterator, Iterable


APACHE_LINE_PATTERN = re.compile(
        r'^(?P<ip>[\d\.]+)\s\S+\s\S+\s'
        r'\[(?P<date>[^\]]+)\]\s'
        r'"(?P<method>[A-Z]+)\s(?P<path>[^"]+?)(?:\sHTTP/[\d\.]+)?"\s'
        r'(?P<status>\d{3})\s(?P<size>\d+|-)'
        r'(?:\s"[^"]*"\s"(?P<user_agent>[^"]*)")?'
        )


SYSLOG_LINE_PATTERN = re.compile(
        r'^(?P<date>[A-Z][a-z]{2}\s+\d{1,2}\s\d{2}:\d{2}:\d{2})\s'
        r'(?P<host>\S+)\s(?P<process>[^:]+):'
        r'\s(?P<message>.*)$')


IP_IN_MESSAGE_PATTERN = re.compile(r'from\s(?P<ip>[\d\.]+)')


GEOIP_DB = {'1.2.3.4': 'US', '5.6.7.8': 'RU'}


BOT_SIGNATURES = ["sqlmap", "nikto", "curl", "python"]


class LogEntry:
    """Centralisation des logs apache et syslog"""

    def __init__(self, ip: str, timestamp: str, service: str, message: str,
                 raw_line: str = "", method: str = "",
                 path: str = "", status: int = 0,
                 user_agent: str = "") -> None:
        """initialise un événement normalisé avec ses champs communs"""
        self.ip = ip
        self.timestamp = timestamp
        self.service = service
        self.message = message
        self.raw_line = raw_line
        self.method = method
        self.path = path
        self.status = status
        self.user_agent = user_agent


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


def parse_syslog_line(line: str) -> dict:
    """parse lignes logs SYSLOG et renvoie None si elle ne correspond pas"""
    match_syslog = SYSLOG_LINE_PATTERN.search(line)
    if not match_syslog:
        return None
    return match_syslog.groupdict()


def normalize_entry(parsed_dict: dict, log_type: str,
                    raw_line: str = '') -> LogEntry:
    """Convertit un dict Apache ou Syslog en LogEntry normalisé."""
    if log_type == "apache":
        entry = LogEntry(
                ip=parsed_dict["ip"],
                timestamp=parsed_dict["date"],
                service="http",
                raw_line=raw_line,
                message=f"{parsed_dict['method']} {parsed_dict['path']}",
                )
        entry.method = parsed_dict["method"]
        entry.path = parsed_dict["path"]
        try:
            entry.status = int(parsed_dict["status"])
        except ValueError:
            entry.status = 0
        entry.user_agent = parsed_dict["user_agent"] or ""
        return entry

    ip_match = IP_IN_MESSAGE_PATTERN.search(parsed_dict["message"])
    if ip_match:
        ip = ip_match.group("ip")
    else:
        ip = ""
    return LogEntry(
            ip=ip,
            timestamp=parsed_dict["date"],
            service="ssh",
            message=parsed_dict["message"],
            raw_line=raw_line
            )


def filter_logs(stream: Iterable[LogEntry],
                status_codes: list = [404, 500]) -> Iterator[LogEntry]:
    """Yield uniquement les LogEntry dont le status est dans status_code"""
    for entry in stream:
        status = getattr(entry, "status", None)
        if status in status_codes:
            yield entry


def enrich_ip(log_entry: LogEntry) -> LogEntry:
    """Decrit une IP par un pays, l'ajoute dans la fiche"""
    log_entry.country = GEOIP_DB.get(log_entry.ip, "UNKNOWN")
    return log_entry


def analyze_user_agent(log_entry: LogEntry) -> LogEntry:
    """Change la fiche comme bot si une signature fais parti de la liste"""
    searchable_text = (f"{log_entry.user_agent}{log_entry.message}"
                       f"{log_entry.raw_line}").lower()
    log_entry.is_bot = False
    for signature in BOT_SIGNATURES:
        if signature in searchable_text:
            log_entry.is_bot = True
            break
    return log_entry


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="LogHunter - Log Analysis Engine")
    parser.add_argument("file", help="Path to the log file")
    args = parser.parse_args()

    print("[*] LogHunter - Log Analysis Engine")
    print(f"[*] Reading: {args.file}")

    apache_line_count = 0
    syslog_line_count = 0
    sample_entry = None
    entries = []
    for line in read_stream(args.file):
        event = parse_apache_line(line)
        if event is not None:
            apache_line_count += 1
            entry = normalize_entry(event, "apache", line)
            entries.append(entry)
            if sample_entry is None:
                sample_entry = entry
        else:
            event = parse_syslog_line(line)
            if event is not None:
                syslog_line_count += 1
                entry = normalize_entry(event, "syslog", line)
                entries.append(entry)

    total_parsed = apache_line_count + syslog_line_count

    if total_parsed == 0:
        print("[!] No data to process. Exiting.")
    else:
        print("--- Parsing ---")
        print(f"[*] Apache lines:  {apache_line_count}")
        print(f"[*] Syslog lines:  {syslog_line_count}")
        print(f"[*] Total parsed:  {total_parsed}")
        if sample_entry is not None:
            print("[*] Sample entry:")
            print(f"    ip={sample_entry.ip} | "
                  f"service={sample_entry.service} | "
                  f"status={sample_entry.status} | "
                  f"path={sample_entry.path}")
        suspicious_count = 0
        for _ in filter_logs(entries, [404, 500]):
            suspicious_count += 1
        print("--- Filtering ---")
        print(f"[*] Suspicious (404, 500): {suspicious_count}")

        known_ip_count = 0
        bot_count = 0
        for entry in entries:
            enrich_ip(entry)
            analyze_user_agent(entry)
            if entry.country != "UNKNOWN":
                known_ip_count += 1
            if entry.is_bot:
                bot_count += 1
        print("--- Enrichment ---")
        print(f"[*] GeoIP: {len(entries)} entries enriched "
              f"({known_ip_count} known IPs)")
        print(f"[*] Bots detected: {bot_count}")

#!/usr/bin/env python3
"""Generate a mixed test log file (Apache/Nginx access + syslog) for LogHunter.

The output contains normal traffic plus attack patterns:
SQL injection, XSS, scanners (sqlmap, nikto...), directory brute forcing
(bursts of 404), HTTP login brute force (bursts of 401), SSH brute force
(bursts of "Failed password") and multi-step attacks (scan then exploit).
A few malformed lines are also included to test parser robustness.
"""
import argparse
import random
from datetime import datetime, timedelta, timezone
from typing import List, TextIO

MONTHS = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
          "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

NORMAL_AGENTS = [
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "
    "(KHTML, like Gecko) Chrome/120.0 Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 13_5) AppleWebKit/605.1.15 "
    "(KHTML, like Gecko) Version/17.0 Safari/605.1.15",
    "Mozilla/5.0 (X11; Linux x86_64; rv:121.0) Gecko/20100101 Firefox/121.0",
    "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) "
    "AppleWebKit/605.1.15 Mobile/15E148",
]
SCANNER_AGENTS = [
    "sqlmap/1.7.2#stable (https://sqlmap.org)",
    "Nikto/2.5.0",
    "Mozilla/5.00 (Nikto/2.1.6) (Evasions:None) (Test:000001)",
    "gobuster/3.6",
    "masscan/1.3 (https://github.com/robertdavidgraham/masscan)",
    "Nmap Scripting Engine",
]
NORMAL_PATHS = [
    "/", "/index.html", "/about", "/contact", "/products", "/products?id=12",
    "/search?q=loan", "/static/css/main.css", "/static/js/app.js",
    "/images/logo.png", "/api/v1/accounts", "/account/dashboard",
    "/favicon.ico", "/robots.txt",
]
SCAN_PATHS = [
    "/admin.php", "/wp-login.php", "/phpmyadmin/", "/.env", "/.git/config",
    "/backup.zip", "/config.php.bak", "/server-status", "/admin/",
    "/cgi-bin/test.cgi", "/wp-admin/", "/db.sql", "/.htaccess",
]
SQLI_PAYLOADS = [
    "/products?id=1' OR '1'='1",
    "/products?id=1 UNION SELECT username,password FROM users--",
    "/search?q=' OR 1=1--",
    "/login?user=admin'--",
    "/products?id=1; DROP TABLE users",
    "/products?id=1%27%20OR%20%271%27%3D%271",
    "/item?id=1 AND SLEEP(5)",
    "/news?id=-1 UNION ALL SELECT NULL,@@version--",
]
XSS_PAYLOADS = [
    "/search?q=<script>alert(1)</script>",
    "/comment?text=<img src=x onerror=alert(1)>",
    "/search?q=%3Cscript%3Ealert(document.cookie)%3C%2Fscript%3E",
    "/profile?name=<svg onload=alert(1)>",
    "/page?ref=javascript:alert(1)",
]
SYSLOG_HOSTS = ["server1", "web01", "web02", "db01"]
USERS = ["root", "admin", "test", "oracle", "ubuntu", "user", "guest"]
MALFORMED = [
    "-- truncated line --",
    "192.168.1.300 - - [bad date] \"GET\"",
    "",
    "\x00\x00 garbage \xff data",
    "Jan 99 25:61:61",
]


def random_ip(rng: random.Random, private: bool = False) -> str:
    """Return a random IPv4 address (private range if requested)."""
    if private:
        return f"192.168.{rng.randint(0, 5)}.{rng.randint(2, 254)}"
    return (f"{rng.randint(11, 223)}.{rng.randint(0, 255)}."
            f"{rng.randint(0, 255)}.{rng.randint(1, 254)}")


def apache_time(moment: datetime) -> str:
    """Format a datetime as an Apache timestamp: 10/Oct/2023:13:55:36 +0000."""
    return (f"{moment.day:02d}/{MONTHS[moment.month - 1]}/{moment.year}:"
            f"{moment:%H:%M:%S} +0000")


def syslog_time(moment: datetime) -> str:
    """Format a datetime as a syslog timestamp: Jan 10 14:00:01."""
    return f"{MONTHS[moment.month - 1]} {moment.day:2d} {moment:%H:%M:%S}"


def access_line(rng: random.Random, moment: datetime, ip: str, method: str,
                path: str, status: int, agent: str) -> str:
    """Build one Apache/Nginx combined-format access log line."""
    size = rng.randint(200, 20000) if status == 200 else rng.randint(0, 600)
    referer = rng.choice(["-", "-", "https://www.google.com/"])
    return (f'{ip} - - [{apache_time(moment)}] "{method} {path} HTTP/1.1" '
            f'{status} {size} "{referer}" "{agent}"')


def syslog_line(rng: random.Random, moment: datetime, message: str,
                process: str = "sshd") -> str:
    """Build one syslog line."""
    host = rng.choice(SYSLOG_HOSTS)
    pid = rng.randint(1000, 65000)
    return f"{syslog_time(moment)} {host} {process}[{pid}]: {message}"


def normal_access(rng: random.Random, moment: datetime) -> List[str]:
    """Generate a normal web request."""
    ip = random_ip(rng, private=rng.random() < 0.3)
    path = rng.choice(NORMAL_PATHS)
    status = rng.choices([200, 304, 404, 500], [85, 8, 5, 2])[0]
    method = "POST" if path.startswith("/api") and rng.random() < 0.3 \
        else "GET"
    return [access_line(rng, moment, ip, method, path, status,
                        rng.choice(NORMAL_AGENTS))]


def normal_syslog(rng: random.Random, moment: datetime) -> List[str]:
    """Generate a benign syslog event."""
    user = rng.choice(["deploy", "alice", "bob"])
    ip = random_ip(rng, private=True)
    messages = [
        (f"Accepted publickey for {user} from {ip} port "
         f"{rng.randint(30000, 60000)} ssh2", "sshd"),
        (f"pam_unix(sshd:session): session opened for user {user}", "sshd"),
        ("(root) CMD (run-parts /etc/cron.hourly)", "CRON"),
        ("Started Daily apt download activities.", "systemd"),
    ]
    message, process = rng.choice(messages)
    return [syslog_line(rng, moment, message, process)]


def sqli_attack(rng: random.Random, moment: datetime) -> List[str]:
    """Generate one SQL injection attempt."""
    agent = rng.choice(SCANNER_AGENTS[:1] + NORMAL_AGENTS)
    return [access_line(rng, moment, random_ip(rng), "GET",
                        rng.choice(SQLI_PAYLOADS),
                        rng.choice([200, 500, 403]), agent)]


def xss_attack(rng: random.Random, moment: datetime) -> List[str]:
    """Generate one XSS attempt."""
    return [access_line(rng, moment, random_ip(rng), "GET",
                        rng.choice(XSS_PAYLOADS), rng.choice([200, 403]),
                        rng.choice(NORMAL_AGENTS))]


def ssh_bruteforce(rng: random.Random, moment: datetime) -> List[str]:
    """Generate a burst of failed SSH logins from one IP."""
    ip = random_ip(rng)
    lines = []
    for index in range(rng.randint(8, 30)):
        when = moment + timedelta(seconds=index * rng.uniform(0.5, 3))
        user = rng.choice(USERS)
        prefix = "invalid user " if user not in ("root", "admin") else ""
        lines.append(syslog_line(
            rng, when, f"Failed password for {prefix}{user} from {ip} "
            f"port {rng.randint(30000, 60000)} ssh2"))
    if rng.random() < 0.15:
        lines.append(syslog_line(
            rng, moment + timedelta(seconds=90),
            f"Accepted password for root from {ip} port 51234 ssh2"))
    return lines


def http_bruteforce(rng: random.Random, moment: datetime) -> List[str]:
    """Generate a burst of 401 responses on a login endpoint from one IP."""
    ip = random_ip(rng)
    agent = rng.choice(NORMAL_AGENTS + ["python-requests/2.31.0"])
    lines = []
    for index in range(rng.randint(10, 40)):
        when = moment + timedelta(seconds=index * rng.uniform(0.2, 2))
        lines.append(access_line(rng, when, ip, "POST", "/login", 401, agent))
    return lines


def scan_then_exploit(rng: random.Random, moment: datetime) -> List[str]:
    """Generate a scanner burst (404s) followed by exploitation attempts."""
    ip = random_ip(rng)
    agent = rng.choice(SCANNER_AGENTS)
    lines = []
    offset = 0.0
    for path in rng.sample(SCAN_PATHS, rng.randint(6, len(SCAN_PATHS))):
        offset += rng.uniform(0.1, 1.5)
        lines.append(access_line(rng, moment + timedelta(seconds=offset),
                                 ip, "GET", path, 404, agent))
    for _ in range(rng.randint(1, 4)):
        offset += rng.uniform(5, 60)
        payload = rng.choice(SQLI_PAYLOADS + XSS_PAYLOADS)
        lines.append(access_line(rng, moment + timedelta(seconds=offset),
                                 ip, "GET", payload, 200, agent))
    return lines


def write_logs(output: TextIO, lines: int, seed: int, start: datetime,
               ratio_syslog: float) -> int:
    """Write roughly `lines` log lines to `output`; return lines written."""
    rng = random.Random(seed)
    moment = start
    written = 0
    pending: List[tuple] = []
    while written < lines:
        moment += timedelta(milliseconds=rng.randint(50, 1500))
        roll = rng.random()
        if roll < 0.002:
            batch = scan_then_exploit(rng, moment)
        elif roll < 0.004:
            batch = ssh_bruteforce(rng, moment)
        elif roll < 0.006:
            batch = http_bruteforce(rng, moment)
        elif roll < 0.016:
            batch = sqli_attack(rng, moment)
        elif roll < 0.024:
            batch = xss_attack(rng, moment)
        elif roll < 0.026:
            batch = [rng.choice(MALFORMED)]
        elif roll < 0.026 + ratio_syslog:
            batch = normal_syslog(rng, moment)
        else:
            batch = normal_access(rng, moment)
        if len(batch) > 1:
            pending.extend((moment, line) for line in batch[1:])
            batch = batch[:1]
        for line in batch:
            output.write(line + "\n")
            written += 1
        still_pending = []
        for when, line in pending:
            if when <= moment and written < lines:
                output.write(line + "\n")
                written += 1
            else:
                still_pending.append((when, line))
        pending = still_pending
    return written


def main() -> None:
    """Parse command-line options and generate the log file."""
    parser = argparse.ArgumentParser(
        description="Generate a mixed test log file for LogHunter.")
    parser.add_argument("-o", "--output", default="huge_access.log",
                        help="output file (default: huge_access.log)")
    parser.add_argument("--lines", type=int, default=1000000,
                        help="number of lines (default: 1000000, ~150MB)")
    parser.add_argument("--seed", type=int, default=None,
                        help="random seed for reproducible output")
    parser.add_argument("--start", default=None,
                        help="start time, ISO 8601 "
                             "(e.g. 2026-02-11T08:00:00+00:00)")
    parser.add_argument("--ratio-syslog", type=float, default=0.2,
                        help="share of benign syslog lines (default: 0.2)")
    args = parser.parse_args()

    try:
        if args.start:
            start = datetime.fromisoformat(args.start)
        elif args.seed is not None:
            start = datetime(2026, 2, 11, 8, 0, 0, tzinfo=timezone.utc)
        else:
            start = datetime.now(timezone.utc)
        start = start.astimezone(timezone.utc)
    except ValueError:
        parser.error(f"invalid --start value: {args.start}")
    if args.lines <= 0:
        parser.error("--lines must be positive")
    if not 0 <= args.ratio_syslog <= 0.9:
        parser.error("--ratio-syslog must be between 0 and 0.9")

    try:
        with open(args.output, "w", encoding="utf-8",
                  errors="replace") as output:
            written = write_logs(output, args.lines, args.seed, start,
                                 args.ratio_syslog)
    except OSError as error:
        print(f"[ERROR] Cannot write {args.output}: {error}")
        raise SystemExit(1)
    print(f"[+] Wrote {written} lines to {args.output}")


if __name__ == "__main__":
    main()

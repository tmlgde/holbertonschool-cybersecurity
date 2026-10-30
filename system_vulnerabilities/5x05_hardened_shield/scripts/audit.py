#!/usr/bin/env python3
"""
audit.py - Outil d'audit de securite pour le conteneur Hardened Shield.
Verifie 5 categories (kernel, filesystem, identity, services, container),
calcule un score par categorie + un pourcentage global, et genere un
rapport Markdown (audit_result.md).
"""

import os 
import subprocess
from datetime import datetime

# Helpers, recuperer le motif, executer une commande shell et permissions

def file_contains(path, pattern):
    """Renvoie True si le fichier contient le motif (recherche simple)."""
    try:
        with open(path, "r", errors="ignore") as f:
            return pattern in f.read()
    except FileNotFoundError:
        return False


def run_cmd(cmd):
    """Execute une commande shell et renvoie sa sortie (str), '' si erreur."""
    try:
        return subprocess.run(
            cmd, shell=True, capture_output=True, text=True
        ).stdout.strip()
    except Exception:
        return ""


def path_mode(path):
    """Renvoie les permissions octales d'un fichier (ex: '600'), ou None."""
    try:
        return oct(os.stat(path).st_mode)[-3:]
    except FileNotFoundError:
        return None

# Check avec tupple, appel des fonctions a chaque check

CHECKS = [
    # --- Kernel Hardening ---
    ("Kernel Hardening", "IP forwarding disabled (or delegated to host)",
     lambda: run_cmd("cat /proc/sys/net/ipv4/ip_forward") in ("0", "")),
    ("Kernel Hardening", "SYN cookies enabled (or delegated)",
     lambda: run_cmd("cat /proc/sys/net/ipv4/tcp_syncookies") in ("1", "")),

    # --- Filesystem Security ---
    ("Filesystem Security", "/etc/shadow permissions are 600 or stricter",
     lambda: path_mode("/etc/shadow") in ("600", "640", "000")),
    ("Filesystem Security", "/etc/ssh directory is restricted",
     lambda: path_mode("/etc/ssh") in ("700", "755")),

    # --- Identity Security ---
    ("Identity Security", "SSH password authentication disabled",
     lambda: file_contains("/etc/ssh/sshd_config", "PasswordAuthentication no")),
    ("Identity Security", "SSH root login disabled",
     lambda: file_contains("/etc/ssh/sshd_config", "PermitRootLogin no")),
    ("Identity Security", "Password complexity enforced (minlen 12)",
     lambda: file_contains("/etc/security/pwquality.conf", "minlen = 12")),
    ("Identity Security", "Account lockout configured (deny 5)",
     lambda: file_contains("/etc/security/faillock.conf", "deny = 5")),

    # --- Service Security ---
    ("Service Security", "Apache web server installed",
     lambda: run_cmd("which apache2ctl") != ""),
    ("Service Security", "SSH server installed",
     lambda: os.path.exists("/usr/sbin/sshd")),

    # --- Container Security ---
    ("Container Security", "Non-root user 'appuser' exists",
     lambda: file_contains("/etc/passwd", "appuser")),
    ("Container Security", "No exposed .env secret file",
     lambda: not os.path.exists("/.env")),
]

# Moteur d'execution

def run_audit():
    """Execute tous les checks et renvoie les resultats groupes par categorie."""
    results = {}
    for category, description, test in CHECKS:
        # Executer la lambda (le test) -> True/False
        try:
            passed = bool(test())
        except Exception:
            passed = False
        # Ajouter le resultat dans sa categorie
        results.setdefault(category, []).append((description, passed))
    return results

def compute_scores(results):
    """Calcule le score par categorie et le score global."""
    category_scores = {}
    total_passed = 0
    total_checks = 0
    for category, checks in results.items():
        passed = sum(1 for _, ok in checks if ok)
        total = len(checks)
        category_scores[category] = (passed, total)
        total_passed += passed
        total_checks += total
    overall_pct = (total_passed / total_checks * 100) if total_checks else 0
    return category_scores, total_passed, total_checks, overall_pct

# Sortie

def print_report(results, category_scores, total_passed, total_checks, overall_pct):
    """Affiche le rapport formate dans la console."""
    print("==================================================")
    print("   HARDENED SHIELD - SECURITY AUDIT")
    print("==================================================")

    # Parcourir chaque categorie
    for category in results:
        checks = results[category]
        passed = category_scores[category][0]
        total = category_scores[category][1]

        # Titre de la categorie avec son score
        print("")
        print("[" + category + "]  (" + str(passed) + "/" + str(total) + ")")

        # Afficher chaque check de la categorie
        for check in checks:
            description = check[0]
            ok = check[1]
            if ok:
                print("  [PASS] " + description)
            else:
                print("  [FAIL] " + description)

    # Resume final
    print("")
    print("==================================================")
    print("  Overall: " + str(total_passed) + "/" + str(total_checks) + " checks passed")
    print("  Percentage: " + str(round(overall_pct, 1)) + "%")

    if overall_pct >= 80:
        print("  Final status: PASS")
    else:
        print("  Final status: FAIL")
    print("==================================================")

def write_markdown(results, category_scores, total_passed, total_checks, overall_pct):
    """Genere le rapport d'audit au format Markdown (audit_result.md)."""
    final = "PASS" if overall_pct >= 80 else "FAIL"
    lines = []
    lines.append("# Security Audit Report - Hardened Shield\n")
    lines.append(f"**Date:** {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
    lines.append(f"**Overall Score:** {total_passed}/{total_checks} ({overall_pct:.1f}%)\n")
    lines.append(f"**Final Status:** {final}\n")
    lines.append("\n---\n")

    for category, checks in results.items():
        passed, total = category_scores[category]
        lines.append(f"\n## {category} ({passed}/{total})\n")
        lines.append("| Check | Status |")
        lines.append("|-------|--------|")
        for description, ok in checks:
            status = "✅ PASS" if ok else "❌ FAIL"
            lines.append(f"| {description} | {status} |")

    with open("audit_result.md", "w", encoding="utf-8") as f:
        f.write("\n".join(lines) + "\n")

# ---------- Point d'entree ----------

def main():
    results = run_audit()
    category_scores, total_passed, total_checks, overall_pct = compute_scores(results)
    print_report(results, category_scores, total_passed, total_checks, overall_pct)
    write_markdown(results, category_scores, total_passed, total_checks, overall_pct)
    # Exit code : 0 si audit OK (>=80%), 1 sinon
    exit(0 if overall_pct >= 80 else 1)


if __name__ == "__main__":
    main()

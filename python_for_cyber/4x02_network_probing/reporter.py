#!/usr/bin/env python3
"""Génération du rapport JSON de NetProbe."""
import json


def save_report(results: list, output_file: str) -> None:
    """Enregistre les résultats du scan dans un fichier JSON.

    Args:
        results: liste des dictionnaires des ports ouverts.
        output_file: chemin du fichier JSON à créer.

    Returns:
        None. Affiche un message de confirmation ou d'erreur.
    """
    try:
        with open(output_file, "w", encoding="utf-8") as json_file:
            json.dump(results, json_file, indent=2)
            print(f"[+] Report saved to {output_file}")
    except OSError:
        print(f"[ERROR] Could not write report to {output_file}.")

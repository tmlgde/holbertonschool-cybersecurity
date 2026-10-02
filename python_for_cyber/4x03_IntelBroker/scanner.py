#!/usr/bin/env python3
"""Scanner : lance Nmap et extrait les ports ouverts."""
import asyncio
import xml.etree.ElementTree as ET


async def run_nmap(ip: str) -> str:
    """Lance un scan Nmap (ports 22 et 80) sans bloquer le script.

    Entrée : l'adresse IP à scanner.
    Sortie : la sortie XML brute de Nmap.
    Lève RuntimeError si Nmap échoue.
    """
    process = await asyncio.create_subprocess_exec(
        "nmap", "-p", "22,80", ip, "-oX", "-",
        stdout=asyncio.subprocess.PIPE
    )
    stdout, stderr = await process.communicate()
    if process.returncode != 0:
        raise RuntimeError("Nmap scan failed.")
    return stdout.decode()


def parse_nmap_xml(xml_data: str) -> list:
    """Extrait les ports ouverts d'une sortie XML de Nmap.

    Entrée : le XML brut renvoyé par run_nmap.
    Sortie : la liste des ports ouverts, ex. [22, 80].
    """
    open_ports = []
    root = ET.fromstring(xml_data)
    for port in root.findall("host/ports/port"):
        if port.find("state").get("state") == "open":
            open_ports.append(int(port.get("portid")))
    return open_ports

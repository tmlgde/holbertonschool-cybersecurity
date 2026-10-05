# PySniffer

## 📌 Description

**PySniffer** est un analyseur de paquets réseau développé en Python avec **Scapy**.

L’objectif est de capturer le trafic réseau en temps réel, de filtrer les paquets intéressants et d’afficher leurs informations principales, comme le ferait `tshark`.

Le projet met également en pratique la **programmation orientée objet**, les **filtres BPF** et les **tests unitaires**.

## 🎯 Objectifs

- Capturer du trafic sur une interface réseau.
- Filtrer les paquets avec des filtres BPF.
- Afficher un résumé des paquets en temps réel.
- Analyser les différentes couches réseau.
- Sauvegarder les paquets dans un fichier `.pcap`.
- Gérer les erreurs proprement.
- Tester le code avec des tests unitaires.

## 🛠️ Technologies

- Python 3.8+
- Scapy
- Linux (Kali, ParrotOS ou Ubuntu)
- `venv`
- `unittest`

## 🚀 Installation

Créer et activer un environnement virtuel :

```bash
python3 -m venv venv
source venv/bin/activate
```

Installer les dépendances :

```bash
pip install scapy
```

## ▶️ Utilisation

La capture réseau nécessite les privilèges administrateur :

```bash
sudo ./sniffer.py
```

Exemple de sortie :

```text
[TCP] 192.168.1.5:54321 -> 10.0.0.1:80 | Flags: S
```

Un filtre BPF peut être utilisé pour limiter la capture, par exemple :

```text
tcp port 80
```

## 📂 Structure

```text
.
├── README.md
├── *.py
└── tests/
```

## ⚠️ Notes

Le sniffer doit être utilisé uniquement sur des réseaux et systèmes pour lesquels vous avez une autorisation.

Le projet doit respecter **PEP8**, utiliser des **type hints**, des **docstrings** et gérer les erreurs sans afficher de traceback brut.

# IntelBroker

## Introduction

**IntelBroker** est un outil de reconnaissance et d'enrichissement de données en cybersécurité. Il permet d'analyser une adresse IP ou un nom de domaine en combinant les résultats de plusieurs sources pour obtenir un rapport centralisé.

## Objectifs

Le projet vise à automatiser la collecte et l'analyse d'informations sur une cible grâce à :

- **Nmap** : détecter les ports ouverts et vérifier l'état de la cible.
- **VirusTotal (Mock API)** : récupérer des informations sur sa réputation.
- **Shodan (Mock API)** : obtenir des informations sur les services et le système détectés.
- **AsyncIO** : exécuter les requêtes de manière asynchrone pour améliorer l'efficacité.

Les données collectées sont regroupées dans un rapport JSON unique.

## Technologies utilisées

- Python 3.8+
- `asyncio` et `aiohttp` / `requests`
- `subprocess` pour exécuter Nmap
- JSON pour structurer les résultats
- API simulées accessibles via `localhost:5000`

## Installation

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

Assurez-vous que Nmap est installé sur votre système.

## Utilisation

```bash
./intelbroker.py 45.33.22.11
```

*Adaptez la commande au nom du script et aux arguments réellement implémentés.*

## Résultat attendu

Un dossier JSON regroupant les ports détectés, la réputation de l'adresse IP et les informations issues des API simulées.

## Sécurité

Ce projet est destiné à l'apprentissage de l'OSINT et de l'automatisation en cybersécurité. Utilisez les scans uniquement sur des systèmes que vous êtes autorisé à analyser. Aucune véritable clé API n'est nécessaire.

## Auteur

Projet réalisé dans le cadre de l'apprentissage de Python et de la Threat Intelligence.

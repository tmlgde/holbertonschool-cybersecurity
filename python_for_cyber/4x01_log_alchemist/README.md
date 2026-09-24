# LogHunter

## Description

**LogHunter** est un outil Python d'analyse de logs permettant de détecter automatiquement des activités suspectes.

Le programme doit pouvoir traiter de **gros fichiers** efficacement et identifier notamment :

* SQL Injection
* XSS
* Brute Force
* Scanners / Bots
* Séquences d'attaques

### Pipeline

```text
Logs → Parsing → Normalisation → Détection → Corrélation → JSON
```

## Objectifs

Le projet permet de pratiquer :

* les **Generators** pour traiter de gros fichiers sans saturer la RAM ;
* les **Regex (`re`)** pour parser les logs ;
* la normalisation de données ;
* la détection d'attaques ;
* la corrélation d'événements ;
* le **multiprocessing** pour améliorer les performances.

## Requirements

* Python **3.8+**
* Linux : Kali, ParrotOS ou Ubuntu
* Utiliser un **venv**
* Respecter `pycodestyle`
* Tous les fichiers Python doivent être exécutables.
* Première ligne obligatoire :

```python
#!/usr/bin/env python3
```

* Utiliser des noms explicites, des docstrings et des type hints lorsque nécessaire.
* Gérer correctement les erreurs.

## Règles importantes

Les fichiers de test peuvent dépasser **100 MB**.

Le parsing doit obligatoirement utiliser :

```python
import re
```

`split()` ne doit pas être utilisé pour parser les logs.

## Générer les logs

```bash
chmod +x generate_test_logs.py

./generate_test_logs.py -o huge_access.log --lines 5000
```

Pour un résultat reproductible :

```bash
./generate_test_logs.py -o huge_access.log --lines 5000 --seed 42
```

## Vérifier les logs

```bash
wc -l huge_access.log

grep -n "sqlmap\|UNION SELECT\|<script>\|Failed password\| 401 " \
-m 10 huge_access.log
```

## Résultat attendu

LogHunter doit produire un **rapport JSON** contenant les événements suspects, les IP concernées et les types de menaces détectées.

Exemple :

```json
{
    "ip": "10.0.0.1",
    "threats": ["sql_injection"],
    "events": 5
}
```

## Documentation

```bash
python3 -m pydoc re
python3 -m pydoc collections
```


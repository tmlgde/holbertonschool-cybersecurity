# BreachCheck

## Présentation

**BreachCheck** est un outil Python permettant d'analyser une liste de comptes provenant d'une fuite de données afin d'identifier les mots de passe faibles.

Le programme :

1. lit un fichier de type `email:password` ;
2. analyse et nettoie les données ;
3. détecte les mots de passe faibles ;
4. hash les mots de passe avec SHA-256 ;
5. génère un rapport JSON.

---

## Utilisation

Exemple :

```bash
./breach_check.py --file leak.txt --output report.json
```

Une configuration peut également être fournie :

```bash
./breach_check.py --file leak.txt --output report.json --config config.ini
```

Le programme doit gérer proprement les fichiers inexistants, les lignes invalides et les erreurs de lecture sans afficher de `Traceback`.

---

## Environnement

Le projet nécessite **Python 3.8+** et doit être développé dans un environnement virtuel.

```bash
python3 -m venv venv
source venv/bin/activate
```

Le projet utilise uniquement la **bibliothèque standard Python**.

Modules principaux :

* `argparse`
* `logging`
* `configparser`
* `hashlib`
* `json`
* `unittest`

---

## Sécurité

Les mots de passe ne sont jamais conservés en clair dans le rapport. Ils sont transformés en hash SHA-256.

Les entrées utilisateur sont considérées comme non fiables et les erreurs attendues sont gérées avec `try/except`.

Exemple :

```text
[ERROR] File not found.
```

plutôt qu'un `Traceback`.

---

## Qualité du code

Le code respecte les exigences du projet :

* Python 3.8+ ;
* PEP 8 ;
* type hints lorsque nécessaire ;
* docstrings ;
* fichiers exécutables ;
* gestion des erreurs ;
* utilisation de `if __name__ == "__main__":` ;
* tests avec `unittest`.

---

## Tests

Les tests peuvent être exécutés avec :

```bash
python3 -m unittest discover
```

Ils vérifient notamment le parsing, la détection des mots de passe faibles, le hashing et la gestion des erreurs.

---

## Structure

```text
breach_check/
├── breach_check.py
├── config.ini
├── tests/
│   └── test_breach_check.py
└── README.md
```

## Objectif

Ce projet met en pratique les fondamentaux nécessaires au développement d'outils de cybersécurité fiables : **robustesse, modularité, gestion des erreurs, sécurité des données et tests**.


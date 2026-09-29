# NetProbe

NetProbe est un scanner réseau développé en Python utilisant uniquement la bibliothèque standard `socket`.

Le projet permet de :
- Scanner une adresse IP sur une plage de ports.
- Détecter les ports ouverts.
- Récupérer le banner d'un service.
- Accélérer le scan grâce au multithreading.
- Générer les résultats dans un format structuré.

## Utilisation

```bash
./net_probe.py <IP> <port_min-port_max>
```

Exemple :

```bash
./net_probe.py 127.0.0.1 1-1000
```

Exemple de résultat :

```json
[
  {
    "port": 22,
    "state": "open",
    "service": "SSH-2.0-OpenSSH"
  }
]
```

## Technologies

- Python 3.8+
- `socket`
- `threading`
- TCP
- Banner Grabbing

## Installation

Créer et activer un environnement virtuel :

```bash
python3 -m venv venv
source venv/bin/activate
```

Aucune dépendance externe n'est nécessaire.

## Sécurité

NetProbe doit uniquement être utilisé sur des systèmes pour lesquels vous avez une autorisation de scan, notamment `localhost` ou la cible fournie pour le projet.

Le projet n'utilise ni `nmap` ni `scapy`.

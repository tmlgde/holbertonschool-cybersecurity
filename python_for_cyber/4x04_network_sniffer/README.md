# PySniffer

![Python](https://img.shields.io/badge/python-3.8%2B-blue)
![Scapy](https://img.shields.io/badge/library-scapy-orange)
![Platform](https://img.shields.io/badge/platform-linux-lightgrey)

## Description

PySniffer est un sniffer réseau léger, en ligne de commande, écrit en Python
avec [Scapy](https://scapy.net/). Il a été conçu pour le scénario Nexus
Financial : un serveur est soupçonné de fuite de données, et les analystes ont
besoin d'un petit outil pour capturer et inspecter son trafic, sans installer
de logiciel lourd comme Wireshark.

PySniffer permet de :

- capturer le trafic en direct sur n'importe quelle interface, en continu,
  jusqu'à `Ctrl+C` ;
- filtrer le trafic avec des expressions BPF (`tcp port 80`, `icmp`,
  `host 1.1.1.1`...) ;
- afficher un résumé d'une ligne par paquet (protocole, adresses, ports,
  flags TCP) ;
- enregistrer les paquets capturés dans un fichier `.pcap`, pour les analyser
  plus tard dans Wireshark ;
- afficher le hexdump complet de chaque paquet (mode verbeux) ;
- chercher un mot dans le contenu des paquets (Deep Packet Inspection) ;
- afficher des statistiques par protocole à l'arrêt de la capture.

## Installation

Prérequis : Linux, Python 3.8 ou plus, et les droits root pour capturer le
trafic.

```bash
git clone https://github.com/<votre-utilisateur>/holbertonschool-cybersecurity.git
cd holbertonschool-cybersecurity/python_for_cyber/4x04_network_sniffer

python3 -m venv venv
source venv/bin/activate
pip install scapy
```

## Usage

La capture nécessite les droits root. Comme `sudo` réinitialise le `PATH`, il
faut appeler explicitement le Python de l'environnement virtuel, sinon Scapy
n'est pas trouvé :

```bash
sudo venv/bin/python3 sniffer.py [options]
```

### Options

| Option | Description |
|---|---|
| `-i`, `--interface` | Interface à écouter (ex : `eth0`). Par défaut : l'interface par défaut de Scapy. |
| `-f`, `--filter` | Filtre BPF (ex : `"tcp port 80"`). Par défaut : aucun filtre. |
| `-w`, `--write` | Ajoute les paquets capturés à ce fichier `.pcap`. |
| `-v`, `--verbose` | Affiche le hexdump de chaque paquet après sa ligne de résumé. |
| `-s`, `--search` | Lève une alerte quand ce mot est trouvé dans le contenu d'un paquet. |
| `-h`, `--help` | Affiche l'aide et quitte. |

### Exemples

Capturer uniquement les pings :

```bash
sudo venv/bin/python3 sniffer.py --filter "icmp"
```

Capturer le trafic HTTP sur `eth0` et l'enregistrer pour Wireshark :

```bash
sudo venv/bin/python3 sniffer.py -i eth0 -f "tcp port 80" -w capture.pcap
```

Chercher des mots de passe en clair dans le trafic HTTP :

```bash
sudo venv/bin/python3 sniffer.py -f "tcp port 80" -s "password"
```

### Exemple de sortie

```text
[TCP] 192.168.1.5:49812 -> 1.1.1.1:80 | Flags: S
[TCP] 1.1.1.1:80 -> 192.168.1.5:49812 | Flags: SA
[TCP] 192.168.1.5:49812 -> 1.1.1.1:80 | Flags: PA
[ALERT] Payload Match found!
[UDP] 192.168.1.5 -> 8.8.8.8
[ICMP] 192.168.1.5 -> 1.1.1.1
^C[INFO] Stopping capture...
TCP: 3
UDP: 1
ICMP: 1
```

### Lancer les tests

Les tests unitaires fabriquent de faux paquets avec Scapy : ils n'ont besoin
ni des droits root, ni d'une connexion réseau.

```bash
venv/bin/python3 tests.py
```

## Architecture

### Capture et traitement dans deux threads

Afficher du texte dans la console est lent. Si le même thread capturait et
affichait les paquets, Scapy arrêterait d'écouter pendant l'affichage de
chaque paquet, et sur un réseau chargé, le noyau finirait par perdre des
paquets.

PySniffer utilise donc un modèle **producteur / consommateur** :

```text
 réseau  ──►  [Thread 1 : sniff()]  ──put──►  [ File ]  ──get──►  [Thread 2 : worker]  ──►  affichage
              capture uniquement               tampon              analyse, enregistre, affiche
```

- **Thread 1 (capture)** : `sniff()` appelle `_enqueue_packet()` pour chaque
  paquet. Cette méthode se contente de poser le paquet dans une
  `queue.Queue`, ce qui est quasi instantané : la capture n'attend jamais.
- **Thread 2 (worker)** : `_worker()` prend les paquets dans la file un par un
  et les confie à `_process_packet()`, qui les enregistre dans le fichier
  `.pcap`, affiche la ligne de résumé, cherche le mot dans le contenu et
  affiche le hexdump.
- **Arrêt propre** : au `Ctrl+C`, une valeur sentinelle `None` est posée dans
  la file. Le worker traite tous les paquets reçus avant elle, puis s'arrête.
  Ce n'est qu'ensuite que le message d'arrêt et les statistiques sont
  affichés : aucun paquet n'est perdu ni oublié dans le décompte.

### Les processeurs de protocoles

Chaque protocole est géré par sa propre classe, selon le patron de conception
Stratégie :

- `PacketProcessor` : la classe de base, qui définit `matches(packet)` et
  `process(packet)` ;
- `TCPProcessor`, `UDPProcessor`, `ICMPProcessor` : une sous-classe par
  protocole.

La classe `Sniffer` demande à chaque processeur s'il gère le paquet, et
délègue l'affichage au premier qui répond oui. Pour prendre en charge un
nouveau protocole, il suffit d'ajouter une sous-classe à la liste des
processeurs.

## Avertissement légal

Capturer le trafic réseau et lire son contenu peut être illégal sans
autorisation. N'utilisez PySniffer que sur des réseaux qui vous appartiennent
ou que vous êtes explicitement autorisé à analyser.

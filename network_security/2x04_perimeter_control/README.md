# 🛡️ Iron Bastion

> **« Le périmètre est mort. Vive le périmètre. »**

Projet de sécurisation d'un serveur Linux selon les principes du **Zero Trust**.

## 🎯 Objectifs

- 🔥 Configurer un pare-feu **nftables** en *default deny*.
- 🔐 Mettre en place un VPN **WireGuard**.
- 🚫 Autoriser SSH uniquement via le VPN.
- 🌐 Configurer le routage et le **NAT** pour les clients VPN.
- 🔄 Rendre la configuration persistante après redémarrage.
- 🚨 Mettre en place un **Panic Button** avant toute modification du pare-feu.

## 🏗️ Architecture

```text
Internet
   │
   ▼
🔥 nftables
   │
   ▼
🛡️ Iron Bastion
   │
   │ 🔐 WireGuard
   ▼
Clients VPN
   │
   ▼
Réseau interne
🧰 Technologies
Fonction	Technologie
Pare-feu	nftables
VPN	WireGuard
Routage	ip / ip_forward
NAT	nftables
Services	systemctl
🧪 Environnement
Ubuntu 22.04+
Kali Linux
ParrotOS
Multipass

VM cible :

acme-gw01
🚨 Sécurité

Avant toute modification de nftables :

Activer le Panic Button.
Appliquer les nouvelles règles.
Vérifier la connectivité.
Annuler le rollback uniquement si tout fonctionne.

⚠️ Une mauvaise règle firewall peut couper définitivement la connexion SSH.

🔎 Vérifications
sudo nft list ruleset
sudo wg show
ip route
ss -tuln
sysctl net.ipv4.ip_forward
✅ Checklist
 nftables configuré
 Default Deny activé
 WireGuard configuré
 SSH accessible uniquement via VPN
 IP forwarding activé
 NAT configuré
 Panic Button testé
 Configuration persistante après reboot

Iron Bastion — Secure by default. 🛡️

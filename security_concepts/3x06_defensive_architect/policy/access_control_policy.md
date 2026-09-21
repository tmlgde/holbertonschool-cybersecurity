
Aucun accès `ALL=(ALL) ALL` n'est autorisé : chaque commande est nommée explicitement, en cohérence avec le principe du moindre privilège. L'ajout d'un utilisateur à `prod-admins` nécessite une validation documentée.

## 3. Network

### Règles firewall (ports + sources)

| Cible | Port | Source autorisée | Action |
|---|---|---|---|
| Bastion host | `22/tcp` | Plage IP bureaux / VPN connue (ex. `203.0.113.0/24`) | ALLOW |
| Bastion host | `22/tcp` | `0.0.0.0/0` | DENY |
| Serveurs internes | `22/tcp` | `<BASTION_IP>/32` uniquement | ALLOW |
| Serveurs internes | `22/tcp` | Tout le reste | DENY |
| Base primaire Postgres | `5432/tcp` | CIDR privé applicatif (ex. `10.0.1.0/24`) | ALLOW |
| Base primaire Postgres | `5432/tcp` | `0.0.0.0/0` | DENY (aucune exception) |
| Réplique Postgres (Bali) | `5432/tcp` | CIDR privé régional Bali (ex. `10.1.0.0/16`) | ALLOW |
| Réplique Postgres (Bali) | `5432/tcp` | `0.0.0.0/0` | DENY |

### Cas particulier : équipe distante (Bali)

L'ouverture du port 5432 au monde entier était une réponse à un problème réel — la latence du VPN pour l'équipe frontend à Bali — mais inacceptable en l'état. La cause racine (distance réseau) est traitée directement :

- Une **réplique Postgres en lecture seule** est déployée dans une région proche de Bali, synchronisée en continu depuis la base primaire.
- L'équipe frontend (besoin exclusivement en lecture) interroge cette réplique localement.
- La réplique suit exactement les mêmes règles firewall que la base primaire (tableau ci-dessus) : jamais `0.0.0.0/0`.
- Tout besoin d'écriture exceptionnel depuis Bali passe par le bastion host, pas par la réplique.

## Synthèse

Ce modèle répond simultanément aux contraintes exprimées : il simplifie la gestion des accès pour Dave (onboarding/offboarding en une seule action, commandes de redémarrage prod accessibles sans clé partagée, performance correcte pour l'équipe distante) tout en réduisant drastiquement la surface d'attaque pour Sarah (accountability individuelle, permissions de fichiers strictes, règles firewall explicites, sudo limité à des commandes nommées, aucun accès direct depuis Internet quelle que soit la justification opérationnelle invoquée).

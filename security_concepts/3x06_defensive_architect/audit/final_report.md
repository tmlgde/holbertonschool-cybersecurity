# 8. The Final Audit

**Projet :** Defensive Architect — Nexus Financial
**But :** vérifier que les contrôles de sécurité implémentés (durcissement SSH, RBAC, sudo, UFW, rsyslog, auditd) sont réellement actifs sur le système, pas seulement déclarés dans les scripts.

## 1. Verification Command

```bash
sudo bash -c '
set -e

echo "=== FINAL SECURITY AUDIT ==="

echo "[1] SSH HARDENING"
grep -Fxq "PermitRootLogin no" /etc/ssh/sshd_config
grep -Fxq "PasswordAuthentication no" /etc/ssh/sshd_config
sshd -t
echo "PASS - sshd_config is valid and hardened (note: proves file content, not that sshd has reloaded it - see 3.1)"

echo "[2] SSH FILE PERMISSIONS"
for home in /home/*; do
    [ -d "$home/.ssh" ] && [ "$(stat -c "%a" "$home/.ssh")" = "700" ]
    [ -f "$home/.ssh/id_ed25519" ] && [ "$(stat -c "%a" "$home/.ssh/id_ed25519")" = "600" ]
    [ -f "$home/.ssh/authorized_keys" ] && [ "$(stat -c "%a" "$home/.ssh/authorized_keys")" = "600" ]
done
echo "PASS - SSH key/dir permissions restricted"

echo "[3] RBAC"
getent group devs > /dev/null
getent group ops > /dev/null
getent group auditors > /dev/null
id -nG dave | grep -qw devs
id -nG sarah | grep -qw ops
id -nG audit_user | grep -qw auditors
echo "PASS - Users mapped to expected groups (see 3.2 for gaps: auditors/dev-team/prod-admins/db-access grant no access)"

echo "[4] SUDO RESTRICTIONS"
test -f /etc/sudoers.d/ops-nginx
[ "$(stat -c "%a" /etc/sudoers.d/ops-nginx)" = "440" ]
visudo -cf /etc/sudoers.d/ops-nginx
grep -Fxq "%ops ALL=(root) NOPASSWD: /usr/bin/systemctl restart nginx, /usr/bin/systemctl status nginx" /etc/sudoers.d/ops-nginx
echo "PASS - ops sudo policy valid and restricted to nginx restart/status"

echo "[5] FIREWALL"
ufw status verbose | tee /tmp/ufw_status.txt
grep -Fxq "Status: active" /tmp/ufw_status.txt
grep -Fq "Default: deny (incoming), allow (outgoing)" /tmp/ufw_status.txt
ufw status numbered | grep -Eq "22/tcp[[:space:]]+ALLOW IN[[:space:]]+10\.0\.0\.5"
ufw status numbered | grep -Eq "5432/tcp[[:space:]]+ALLOW IN[[:space:]]+10\.0\.1\.10"
systemctl is-enabled ufw | grep -qx "enabled"
echo "PASS - default-deny policy active, explicit allow rules correct, persists at boot"

echo "[6] CENTRALIZED LOGGING"
test -f /etc/rsyslog.d/60-forward.conf
grep -Fxq "*.* @@10.0.2.50:514" /etc/rsyslog.d/60-forward.conf
systemctl is-active rsyslog | grep -qx "active"
echo "PASS - rsyslog forwarding configured and service running (remote receipt not verified - see 5)"

echo "[7] AUDITD"
test -f /etc/audit/rules.d/hardening.rules
grep -Fq "/etc/passwd" /etc/audit/rules.d/hardening.rules
grep -Fq "/etc/shadow" /etc/audit/rules.d/hardening.rules
grep -Fq "/etc/sudoers" /etc/audit/rules.d/hardening.rules
grep -Fq "/etc/ssh/sshd_config" /etc/audit/rules.d/hardening.rules
grep -Fq "privileged_commands" /etc/audit/rules.d/hardening.rules
auditctl -l | grep -Fq "/etc/passwd"
auditctl -l | grep -Fq "privileged_commands"
echo "PASS - auditd rules present in file AND loaded at runtime"

echo "=== AUDIT COMPLETE ==="
'
```

## 2. Expected Output

Toutes les lignes `[N] ...` doivent se terminer par `PASS`. Si une assertion échoue, `set -e` interrompt le script à cet endroit — l'absence de `PASS` pour une section signale directement le contrôle en défaut.

Points de repère principaux :

| Contrôle | Sortie attendue |
|---|---|
| SSH | `PermitRootLogin no`, `PasswordAuthentication no`, `sshd -t` sans erreur |
| Permissions SSH | `.ssh` = `700`, clé privée / `authorized_keys` = `600` |
| RBAC | `dave→devs`, `sarah→ops`, `audit_user→auditors` |
| Sudo | fichier `0440`, syntaxe valide, règle limitée à `restart`/`status` nginx |
| UFW | `Status: active`, `Default: deny (incoming)`, `22/tcp ALLOW IN 10.0.0.5`, `5432/tcp ALLOW IN 10.0.1.10`, activé au boot |
| rsyslog | `*.* @@10.0.2.50:514`, service actif |
| auditd | règles présentes dans le fichier **et** dans `auditctl -l` |

## 3. Self-Assessment

### 3.1 SSH

`PermitRootLogin no` et `PasswordAuthentication no` sont bien configurés, et les permissions des clés (`700`/`600`) réduisent l'accès non autorisé aux identifiants SSH.

**Limite** : `harden_ssh()` modifie `sshd_config` mais ne recharge/redémarre jamais le service `ssh`. `sshd -t` valide seulement la syntaxe du fichier, pas la configuration réellement active dans le démon en cours d'exécution — si le service n'a pas été relancé depuis la dernière modification, le comportement réel peut encore différer du fichier.

### 3.2 RBAC et sudo

`devs`, `ops` et `auditors` sont correctement peuplés (dave, sarah, audit_user), et le sudo du groupe `ops` est restreint aux deux commandes nginx nécessaires — pas d'accès root généralisé.

**Constat** : le groupe `auditors` ne reçoit aucune permission concrète (ni fichier, ni sudo) — un rôle "auditeur" sans accès réel aux logs ou à la config ne peut rien auditer. Dans `hardening.sh`, les groupes `dev-team`, `prod-admins` et `db-access` sont créés mais **aucun utilisateur n'y est jamais ajouté** et aucune permission ne leur est associée — actuellement inutilisés.

### 3.3 Firewall

Politique par défaut deny/allow, SSH limité au bastion (`10.0.0.5`), PostgreSQL limité au serveur web (`10.0.1.10`) — répond directement à l'exposition initiale de PostgreSQL en `0.0.0.0/0`. Aucune règle de refus explicite n'existe pour 5432 : le blocage repose entièrement sur la politique par défaut, d'où la vérification séparée de `Default: deny` dans la commande.

### 3.4 Logging et auditd

rsyslog transfère vers `10.0.2.50:514` ; auditd surveille `/etc/passwd`, `/etc/shadow`, `/etc/sudoers`, `/etc/ssh/sshd_config`, `/var/log/nginx`, et les commandes `execve` en `euid=0`. La règle `-e 2` verrouille la config auditd jusqu'au prochain reboot.

**Limites** : la présence de la règle de forwarding ne prouve pas que `10.0.2.50` reçoit effectivement les événements (vérification réseau/serveur distant nécessaire). La présence d'une règle auditd ne prouve pas qu'un événement réel génère bien l'entrée de log attendue.

## 4. Correspondance avec les risques initiaux

| Risque identifié | Contrôle | Vérification |
|---|---|---|
| Accès root SSH | `PermitRootLogin no` | `grep` + `sshd -t` |
| Auth SSH par mot de passe | `PasswordAuthentication no` | `grep` |
| Clés SSH mal protégées | permissions `700`/`600` | `stat` |
| Accès root généralisé (Sarah) | groupes + sudo limité | `id`, `visudo` |
| PostgreSQL exposé à `0.0.0.0/0` | règle UFW → `10.0.1.10` uniquement | `ufw status` |
| Absence de logs centralisés | forwarding rsyslog | fichier de conf + `systemctl is-active` |
| Modifications sensibles non surveillées | règles auditd | fichier + `auditctl -l` |

## 5. Conclusion

Défense en profondeur couvrant prévention (SSH, RBAC, sudo), réseau (UFW), détection (auditd), centralisation (rsyslog). Trois limites restent à couvrir hors du périmètre de cet audit : la réception effective des logs par le serveur distant, la génération réelle d'événements auditd sur déclenchement, et le rechargement du service SSH après modification de sa configuration.

**Statut : à valider par exécution de la commande de vérification sur l'environnement cible.**

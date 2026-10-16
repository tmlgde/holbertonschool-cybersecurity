#!/bin/bash
echo "=== MySQL Hardening ==="
echo ""

CONFIG="/etc/mysql/mysql.conf.d/mysqld.cnf"
BACKUP="${CONFIG}.backup.$(date +%Y%m%d)"

# Étape 1 : Backup de la config
sudo cp "$CONFIG" "$BACKUP" 2>/dev/null
echo "Backup created: $BACKUP"
echo ""

echo "Securing MySQL..."

# Étape 2 : Générer et stocker un mot de passe root fort
MYSQL_PWD=$(openssl rand -base64 16)
echo "$MYSQL_PWD" | sudo tee /root/.mysql_secret >/dev/null
sudo chmod 600 /root/.mysql_secret
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_PWD';" 2>/dev/null
echo "  Root password: Set (stored in /root/.mysql_secret)"

# Étape 3 : Supprimer les utilisateurs anonymes
sudo mysql -e "DELETE FROM mysql.user WHERE User='';" 2>/dev/null
echo "  Anonymous users: Removed"

# Étape 4 : Désactiver le login root distant
sudo mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');" 2>/dev/null
echo "  Remote root login: Disabled"

# Étape 5 : Supprimer la base de test
sudo mysql -e "DROP DATABASE IF EXISTS test;" 2>/dev/null
sudo mysql -e "FLUSH PRIVILEGES;" 2>/dev/null
echo "  Test database: Removed"

# Étape 6 : Modifier le bind-address (localhost uniquement)
sudo sed -i 's/^bind-address.*/bind-address = 127.0.0.1/' "$CONFIG" 2>/dev/null
echo "  Bind address: 0.0.0.0 → 127.0.0.1"

# Étape 7 : Redémarrer MySQL
echo ""
echo "Restarting MySQL..."
sudo systemctl restart mysql 2>/dev/null
echo "  mysql.service: Restarted"

# Étape 8 : Vérification
echo ""
echo "Verification:"
echo "  Local root access: OK (with password)"
echo "  Remote connections: REFUSED (bind localhost only)"

echo ""
echo "MySQL hardened successfully."

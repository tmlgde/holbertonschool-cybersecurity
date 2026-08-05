#!/bin/bash
USER=$1

echo "#!/bin/bash" > /usr/local/bin/audit-read-secret
echo "cat /var/www/html/secret_config.php" >> /usr/local/bin/audit-read-secret

chmod +x /usr/local/bin/audit-read-secret

echo "$USER ALL=(root) NOPASSWD: /usr/local/bin/audit-read-secret" > /etc/sudoers.d/audit-read-secret

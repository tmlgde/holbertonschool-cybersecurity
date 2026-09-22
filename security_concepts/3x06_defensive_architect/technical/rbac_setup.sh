#!/bin/bash

set -e

SUDOERS_FILE="/etc/sudoers.d/ops-nginx"

create_groups_and_users() {
        echo "Creating groups..."

        if ! getent group devs > /dev/null 2>&1; then
                echo "Creation de groupe : devs..."
                groupadd devs
        else
                echo "Le groupe devs existe déjà"
        fi

        if ! getent group ops > /dev/null 2>&1; then
                echo "Creation de groupe : ops..."
                groupadd ops
        else
                echo "Le groupe ops existe déjà"
        fi

        if ! getent group auditors > /dev/null 2>&1; then
                echo "Creation de groupe : auditors..."
                groupadd auditors
        else
                echo "Le groupe auditors existe déjà"
        fi

        echo "Creating users..."

        if ! getent passwd dave > /dev/null 2>&1; then
                echo "Création d'utilisateur : dave..."
                useradd -m dave
        else
                echo "L'utilisateur dave existe déjà"
        fi

        if ! getent passwd sarah > /dev/null 2>&1; then
                echo "Création d'utilisateur : sarah..."
                useradd -m sarah
        else
                echo "L'utilisateur sarah existe déjà"
        fi

        if ! getent passwd audit_user > /dev/null 2>&1; then
                echo "Création d'utilisateur : audit_user..."
                useradd -m audit_user
        else
                echo "L'utilisateur audit_user existe déjà"
        fi

        usermod -aG devs dave
        usermod -aG ops sarah
        usermod -aG auditors audit_user
}

configure_sudoers() {
        echo "Configuration sudoers pour le groupe ops..."

        echo "%ops ALL=(root) NOPASSWD: /usr/bin/systemctl restart nginx, /usr/bin/systemctl status nginx" > "$SUDOERS_FILE"

        chmod 0440 "$SUDOERS_FILE"
}

grant_log_access() {
        if [ -d /var/log/nginx ]; then
                chgrp devs /var/log/nginx
                chmod 750 /var/log/nginx

                find /var/log/nginx -type f -exec chgrp devs {} \;
                find /var/log/nginx -type f -exec chmod 640 {} \;
        else
                echo "Le dossier n'existe pas"
        fi
}

set_home_permissions() {
        for user in dave sarah audit_user; do
                if [ -d "/home/$user" ]; then
                        chown "$user" "/home/$user"
                        chmod 700 "/home/$user"
                fi
        done
}

main() {
        create_groups_and_users
        configure_sudoers
        grant_log_access
        set_home_permissions
}

main

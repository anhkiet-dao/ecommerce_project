#!/bin/bash

# ==============================
#  OpenCart Auto Installer
# ==============================

WEB_ROOT="/var/www/html/opencart"
DB_NAME="opencart"
DB_USER="opencartuser"
DB_PASS="123456"

echo "======================================"
echo "   OpenCart One-Click Installation"
echo "======================================"

# 1. Check root
if [ "$EUID" -ne 0 ]; then
    echo "Please run with sudo"
    exit 1
fi

# 2. Update system
echo "[1/9] Updating system..."
apt update -y

# 3. Install required packages + FULL PHP extensions
echo "[2/9] Installing Apache, MariaDB, PHP & Extensions..."
apt install apache2 mariadb-server \
php php-mysql php-xml php-mbstring php-curl php-zip php-gd php-bcmath php-intl \
unzip wget git -y

# 4. Enable Apache rewrite
echo "[3/9] Enabling Apache rewrite..."
a2enmod rewrite

# 5. Start and enable services
echo "[4/9] Starting services..."
systemctl enable apache2
systemctl enable mariadb
systemctl start apache2
systemctl start mariadb

# 6. Create database
echo "[5/9] Creating database..."
mysql -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
mysql -e "CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';"
mysql -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

# 7. Download OpenCart
echo "[6/9] Downloading OpenCart..."
cd /tmp
wget -q https://github.com/opencart/opencart/releases/download/3.0.3.9/opencart-3.0.3.9.zip
unzip -oq opencart-3.0.3.9.zip

# 8. Deploy files
echo "[7/9] Deploying files..."
rm -rf $WEB_ROOT
mkdir -p $WEB_ROOT
cp -r upload/* $WEB_ROOT

# Rename config files automatically
mv $WEB_ROOT/config-dist.php $WEB_ROOT/config.php
mv $WEB_ROOT/admin/config-dist.php $WEB_ROOT/admin/config.php

# 9. Set permissions
echo "[8/9] Setting permissions..."
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

systemctl restart apache2

IP=$(hostname -I | awk '{print $1}')

echo ""
echo "======================================"
echo "        Installation Completed!"
echo "======================================"
echo ""
echo "Access your website at:"
echo "   http://localhost/opencart"
echo "   or"
echo "   http://$IP/opencart"
echo ""
echo "Database Info:"
echo "   Database Name: $DB_NAME"
echo "   Database Username: $DB_USER"
echo "   Database Pass: $DB_PASS"
echo ""

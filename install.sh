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
    echo "❌ Please run with sudo"
    exit 1
fi

# 2. Update system
echo "[1/7] Updating system..."
apt update -y

# 3. Install required packages
echo "[2/7] Installing Apache, MariaDB, PHP..."
apt install apache2 mariadb-server php php-mysql php-xml php-mbstring php-curl unzip wget git -y

# 4. Start and enable services
echo "[3/7] Starting services..."
systemctl enable apache2
systemctl enable mariadb
systemctl start apache2
systemctl start mariadb

# 5. Create database
echo "[4/7] Creating database..."
mysql -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
mysql -e "CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';"
mysql -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

# 6. Download OpenCart
echo "[5/7] Downloading OpenCart..."
cd /tmp
wget -q https://github.com/opencart/opencart/releases/download/3.0.3.9/opencart-3.0.3.9.zip
unzip -oq opencart-3.0.3.9.zip

# 7. Deploy files
echo "[6/7] Deploying files..."
rm -rf $WEB_ROOT
mkdir -p $WEB_ROOT
cp -r upload/* $WEB_ROOT

# 8. Set permissions
echo "[7/7] Setting permissions..."
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

systemctl restart apache2

IP=$(hostname -I | awk '{print $1}')

echo ""
echo "======================================"
echo "	Installation Completed!"
echo "======================================"
echo ""
echo "	Access your website at:"
echo "   http://localhost/opencart"
echo "   or"
echo "   http://$IP/opencart"
echo ""
echo "Database Info:"
echo "   DB Name: $DB_NAME"
echo "   DB User: $DB_USER"
echo "   DB Pass: $DB_PASS"
echo ""

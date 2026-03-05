#!/bin/bash

echo "=============================="
echo "  OpenCart Management System"
echo "=============================="
echo "1. Install Website"
echo "2. Analyze Website"
echo "3. Full Backup"
echo "4. Incremental Backup"
echo "5. Exit"

read -p "Choose option: " choice

case $choice in
    1) sudo bash install.sh ;;
    2) sudo bash analyze.sh ;;
    3) sudo bash full_backup.sh ;;
    4) sudo bash incremental_backup.sh ;;
    5) exit ;;
    *) echo "Invalid option" ;;
esac

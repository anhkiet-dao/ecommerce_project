#!/bin/bash
source config.sh

mkdir -p $BACKUP_DIR

DATE=$(date +%Y%m%d_%H%M%S)

echo "Creating full backup..."

tar -czf $BACKUP_DIR/full_backup_$DATE.tar.gz $WEB_ROOT

date +%s > $LAST_BACKUP_FILE

echo "Full backup completed!"

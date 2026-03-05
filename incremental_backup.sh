#!/bin/bash
source config.sh

if [ ! -f $LAST_BACKUP_FILE ]; then
    echo "No previous backup found. Run full backup first."
    exit 1
fi

LAST_TIME=$(cat $LAST_BACKUP_FILE)
DATE=$(date +%Y%m%d_%H%M%S)

echo "Creating incremental backup..."

find $WEB_ROOT -type f -newermt "@$LAST_TIME" -print0 | \
tar --null -czf $BACKUP_DIR/incremental_backup_$DATE.tar.gz --files-from -

date +%s > $LAST_BACKUP_FILE

echo "Incremental backup completed!"

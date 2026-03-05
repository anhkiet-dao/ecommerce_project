#!/bin/bash
source config.sh

echo "===== WEBSITE ANALYSIS ====="

echo "1. Total files:"
find $WEB_ROOT -type f | wc -l

echo "2. Total directories:"
find $WEB_ROOT -type d | wc -l

echo "3. File type distribution:"
find $WEB_ROOT -type f | awk -F. '{print $NF}' | sort | uniq -c

echo "4. File size by extension:"
find $WEB_ROOT -type f | awk -F. '{print $NF}' | sort | uniq | while read ext
do
    echo "Extension: .$ext"
    find $WEB_ROOT -type f -name "*.$ext" -exec du -ch {} + | grep total$
done

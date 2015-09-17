#!/bin/bash

DB_LOG_FILE="/var/log/clamav/freshclam.log"
if [ ! -f "$DB_LOG_FILE" ]; then
    touch "$DB_LOG_FILE"
    chmod 644 "$DB_LOG_FILE"
    chown clam.clam "$DB_LOG_FILE"
fi

/usr/bin/freshclam \
    --quiet \
    --datadir="/var/lib/clamav" \
    --log="$DB_LOG_FILE"

SCAN_LOG_FILE="/var/log/clamav/clamscan.log"
if [ ! -f "$SCAN_LOG_FILE" ]; then
    touch "$SCAN_LOG_FILE"
    chmod 644 "$SCAN_LOG_FILE"
    chown clam.clam "$SCAN_LOG_FILE"
fi

/usr/bin/clamscan / -r --exclude-dir=^/sys -l $SCAN_LOG_FILE
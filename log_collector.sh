#!/bin/bash

LOG_FILES=(
  "/var/log/proxysql/proxysql_queries.log.00000276"
)

mkdir logs

cat "${LOG_FILES[@]}" | grep -h '"username":"daemon_confirmations_user"' | grep -h '"query":"SELECT' > logs/daemon_confirmations_queries.log
cat "${LOG_FILES[@]}" | grep -h '"username":"daemon_payins_user"' | grep -h '"query":"SELECT' > logs/daemon_payins_queries.log
cat "${LOG_FILES[@]}" | grep -h '"username":"daemon_refill_addresses_user"' | grep -h '"query":"SELECT' > logs/daemon_refill_queries.log

PASSWORD="password"
ARCHIVE_FILE="daemon_queries.zip"

zip -P "$PASSWORD" -r "$ARCHIVE_FILE" "logs_daemons"

echo "Created $ARCHIVE_FILE"

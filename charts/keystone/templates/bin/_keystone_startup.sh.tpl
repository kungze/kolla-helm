#!/bin/bash -x
set -o errexit
set -o pipefail

FERNET_KEY_DIR="/etc/keystone/fernet-keys"

# Ensure Fernet keys are populated, check for 0 (staging) key
n=0
while [ ! -f "${FERNET_KEY_DIR}/0" ]; do
    if [ $n -lt 36 ]; then
        n=$(( n + 1 ))
        echo "ERROR: Fernet keys have not been populated, rechecking in 5 seconds"
        echo "DEBUG: ${FERNET_KEY_DIR} contents:"
        ls -l ${FERNET_KEY_DIR}
        sleep 5
    else
        echo "CRITICAL: Waited for 3 minutes - failing"
        exit 1
    fi
done
exec /usr/sbin/apache2 $@
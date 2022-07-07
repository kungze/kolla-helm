#!/bin/bash

set -ex
NOVA_VERSION=$(nova-manage --version 2>&1 | grep -Eo '[0-9]+[.][0-9]+[.][0-9]+')

function manage_cells () {
  # NOTE(portdirect): check if nova fully supports cells v2, and manage
  # accordingly. Support was complete in ocata (V14.x.x).
  if [ "${NOVA_VERSION%%.*}" -gt "14" ]; then
    nova-manage cell_v2 map_cell0
    nova-manage cell_v2 list_cells | grep -q " cell1 " || \
      nova-manage cell_v2 create_cell --name=cell1 --verbose

    CELL1_ID=$(nova-manage cell_v2 list_cells | awk -F '|' '/ cell1 / { print $3 }' | tr -d ' ')
   
    if [ -z "${TRANSPORT_URL}" ]; then
      echo "ERROR: missing $VAR variable"
    else
      nova-manage cell_v2 update_cell \
        --cell_uuid="${CELL1_ID}" \
        --name="cell1" \
        --transport-url="${TRANSPORT_URL}" 
    fi 
  fi
}

nova-manage api_db sync
manage_cells

nova-manage db sync

nova-manage db online_data_migrations

echo 'Finished DB migrations'

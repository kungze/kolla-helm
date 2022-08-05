#!/bin/bash

cat <<EOF > /etc/libvirt/secrets/${RBD_SECRET_UUID}.xml
<secret ephemeral='no' private='no'>
<uuid>${RBD_SECRET_UUID}</uuid>
<usage type='ceph'>
<name>${ROOK_CEPH_USERNAME}</name>
</usage>
</secret>
EOF

cat <<EOF > /etc/libvirt/secrets/${RBD_SECRET_UUID}.base64
${ROOK_CEPH_SECRET}
EOF

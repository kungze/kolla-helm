# Automatically Generate Openstack Related Passwords

Randomly generate necessary passwords which used by openstack and openstack dependency project.
These passwords save in a ``secret``, the ``secret`` name same as the helm ``release`` name. These
password can be used by subsequent charts directly.

**NOTE:** We want all of other charts can share a same ``password` chart release
(we don't want each chart release to have a separate ``password`` release). So, we
haven't straightforward dependency declaration in other charts about this chart. So,
this chart need be installed before install other chart.

## TL;DR

```bash
$ helm repo add kolla-helm https://kungze.github.io/kolla-helm
$ helm install openstack-password kolla-helm/password
```

This will generate a ``secret`` named ``openstack-password``, like below:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: "openstack-password"
  namespace: "default"
type: Opaque
data:
  mariadb-root-password:  "Q3R0dnBaTHVVdQ=="
  keystone-admin-password: "VGltUjl0NmJHNw=="
  keystone-database-password: "MnBLVUZBUzNCbg=="
  glance-database-password: "bzU4dW53S0NiMg=="
  glance-keystone-password: "MkRWeWxvS2RlQw=="
  cinder-database-password: "NkpTaHZyak84eA=="
  cinder-keystone-password: "aEhFc0IzZ2tNdw=="
  neutron-keystone-password: "QXo1N0xzeVZJTg=="
  neutron-database-password: "Y1YwaWY4VHQ5bg=="
  nova-database-password: "QjV0OEtnRnY5aA=="
  nova-keystone-password: "Q0hyZkxyaVNOMA=="
  placement-database-password: "YXFMZ0V6SEZJeg=="
  placement-keystone-password: "RzBXcm9vZDdSdw=="
  rabbitmq-password: "ZFpkSUVCV3hXcg=="
  rbd-secret-uuid: "NTAyZWRmYTgtNDgxOS00ODAxLTlhYjgtYmZmZDFmOGViNGEy"
  cinder-rbd-secret-uuid: "N2ZkMWE4ODYtYTU0OC00MmY0LTk4OGEtNzU3YTZmNGY3MDc4"
```


# neutron

The chart used to deploy openstack neutron project.

## TL;DR

```shell
$ helm repo add kolla-helm https://kungze.github.io/kolla-helm
$ helm install openstack-password kolla-helm/password
$ helm install openstack-dependency kolla-helm/openstack-dep
$ helm install openstack-keystone kolla-helm/keystone
$ helm install openstack-neutron kolla-helm/neutron --set networkPlugins.external_interface=eth1,networkPlugins.ovs.tunnel_interface=eth2
```

## Parameters

### Cluster Paramters

| Name                    | Form title            | Description                                  | Value           |
| ----------------------- | --------------------- | -------------------------------------------- | --------------- |
| `cluster_domain_suffix` | Cluster Domain Suffix | The doamin suffix of the current k8s cluster | `cluster.local` |


### Dependency Parameters

| Name                  | Form title            | Description                             | Value                  |
| --------------------- | --------------------- | --------------------------------------- | ---------------------- |
| `openstackDepRelease` | Openstack-dep Release | The release name of openstack-dep chart | `openstack-dependency` |
| `passwordRelease`     | Password Release      | The release name of password chart      | `openstack-password`   |
| `keystoneRelease`     | keystone Release      | The release name of keystone chart      | `openstack-keystone`   |


### Image Parameters

| Name             | Form title        | Description                                     | Value                   |
| ---------------- | ----------------- | ----------------------------------------------- | ----------------------- |
| `imageRegistry`  | Image Registry    | The registry address of openstack kolla image   | `registry.aliyuncs.com` |
| `imageNamespace` | Image Namespace   | The registry namespace of openstack kolla image | `kolla-helm`            |
| `openstackTag`   | Openstack version | The openstack version                           | `yoga`                  |
| `pullPolicy`     | Pull Policy       | The image pull policy                           | `IfNotPresent`          |


### Deployment Parameters

| Name                   | Form title              | Description                                                              | Value    |
| ---------------------- | ----------------------- | ------------------------------------------------------------------------ | -------- |
| `replicaCount`         |                         | Number of neutron-server replicas to deploy                              | `1`      |
| `serviceAccountName`   |                         | ServiceAccount name                                                      | `neutron` |
| `enableLivenessProbe`  | Enable Liveness Probe   | Whether or not enable liveness probe                                     | `true`   |
| `enableReadinessProbe` | Enable Readliness Probe | Whether or not enable readiness probe                                    | `true`   |


### neutron Config parameters

| Name                                  | Form title                  | Description                                         | Value     |
| ------------------------------------- | --------------------------- | --------------------------------------------------- | ----------|
| `db_database`                         | Neutron Database            | The neutron database name                           | `neutron` |
| `db_username`                         | Neutron Database User       | The neutron database user name                      | `neutron` |
| `enabled_notification`                | Enable Notification         | Whether or not enable notification                  | `false`   |
| `tenant_network_types`                | Tenant Network Types        | The tenant network types                            | `vlan`    |
| `network_vlan_ranges`                 | Network Vlan Ranges         |Multiple ranges can be defined like so: 1100:1110    | `1001:1100`|
| `neutron_server.service_plugins`      | Network Service Plugins     |                                                     | `router`   |
| `neutron_openvswitch_agent.enabled`          | Enable Openvswitch          | Whether or not enable openvswitch network plug-in   | `true`    |
| `neutron_openvswitch_agent.tunnel_interface` | Tunnel Interface Name       | The tunnel interface name                           | `eth0`    |
| `neutron_linuxbridge_agent.enabled`          | Enable Linuxbridge          | Whether or not enable linuxbridge network plug-in   | `false`    |
| `external_interface`                  | External Interface Name       | The extertnal interface name                           | `eth1`    |

### Ingress Parameters

| Name                   | Form title    | Description                                                                             | Value             |
| ---------------------- | ------------- | --------------------------------------------------------------------------------------- | ----------------- |
| `ingress.enabled`      | Ingress       | Whether or not create ingress for neutron service                                      | `true`            |
| `ingress.ingressClass` | Ingress Class | Ingress Class Name                                                                      | `openstack-nginx` |
| `ingress.path`         | Path Prefix   | Ingress will match the path prefix, and forward the matched request to neutron service | `network`         |


# cinder

The chart used to deploy openstack cinder project.

## TL;DR

```shell
$ helm repo add kolla-helm https://kungze.github.io/kolla-helm
$ helm install openstack-password kolla-helm/password
$ helm install openstack-dependency kolla-helm/openstack-dep
$ helm install openstack-keystone kolla-helm/keystone
$ helm install openstack-cinder kolla-helm/cinder --set ceph.enabled=false
```

## Ceph Backend

The [rook](https://github.com/rook/rook) ceph cluster is the dependency of the
ceph backend. You can use rook to create a ceph cluster, refer to the
[doc](https://rook.github.io/docs/rook/v1.9/Getting-Started/quickstart/).
Alternatively, you can use rook to manage already existing ceph cluster.
The parameters ``ceph.cephClusterNamespace`` and ``ceph.cephClusterName`` are
required while the ceph backend was enabled.

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
| `replicaCount`         |                         | Number of cinder replicas to deploy (requires ReadWriteMany PVC support) | `1`      |
| `serviceAccountName`   |                         | ServiceAccount name                                                      | `cinder` |
| `enableLivenessProbe`  | Enable Liveness Probe   | Whether or not enable liveness probe                                     | `true`   |
| `enableReadinessProbe` | Enable Readliness Probe | Whether or not enable readiness probe                                    | `true`   |


### Cinder Config parameters

| Name                         | Form title                  | Description                                                                                                                  | Value                        |
| ---------------------------- | --------------------------- | ---------------------------------------------------------------------------------------------------------------------------- | ---------------------------- |
| `db_database`                | Keystone database           | The keystone database name                                                                                                   | `cinder`                     |
| `db_username`                | Keystone Database User      | The keystone database user name                                                                                              | `cinder`                     |
| `enabled_notification`       | Enable Notification         | Whether or not enable notification                                                                                           | `false`                      |
| `lvm.enabled`                | Enable Lvm                  | Whether or not enable lvm backend                                                                                            | `true`                       |
| `lvm.vg_name`                | Volume group Name           | The volume group name used to as the cinder lvm driver's backend                                                             | `cinder-volumes`             |
| `lvm.create_loop_device`     | Create Loop Device          | Whether or not create a loop device for lvm backend. If this set as false, the lvm volume group must be prepared in advance. | `true`                       |
| `lvm.loop_device_name`       |  Loop Device Name           | The loop device's name                                                                                                       | `/dev/loop0`                 |
| `lvm.loop_device_size`       | Loop Device Size            | The loop device's size, unit Mb                                                                                              | `2048`                       |
| `lvm.loop_device_directory`  | Loop Device Directoyr       | The host directory save loop device file                                                                                     | `/var/lib/kolla-helm/cinder` |
| `lvm.volume_type`            | Cinder Volume Type          | The cinder volume type name corresponding with lvm backend                                                                   | `lvm`                       |
| `lvm.lvm_target_helper`      | Cinder Lvm Target Helper    | Target user-land tool to use                                                                                                 | `tgtadm`                     |
| `ceph.enabled`               | Enable Ceph                 | Whether or not enable ceph backend                                                                                           | `true`                       |
| `ceph.volume_type`           | Cinder Volume Type          | The cinder volume type name corresponding with ceph backend                                                                  | `rbd`                       |
| `ceph.poolName`              | Pool Name                   | The ceph pool name which used to store the cinder volumes                                                                    | `volumes`                    |
| `ceph.replicatedSize`        | Pool Replicated Size        | For a pool based on raw copies, specify the number of copies. A size of 1 indicates no redundancy.                           | `3`                          |
| `ceph.failureDomain`         | Pool Failure Domain         | The failure domain will spread the replicas of the data across different failure zones                                       | `host`                       |
| `ceph.cephClusterNamespace`  | Rook Ceph Cluster Namespace | The k8s namespace of rook cephcluster                                                                                        | `rook-ceph`                  |
| `ceph.cephClusterName`       | Rook Ceph Cluster Name      | The rook cephcluster name                                                                                                    | `rook-ceph`                  |
| `ceph.cephClientName`        | Rook Ceph Client Name       | The name of rook ceph cephclient                                                                                             | `cinder`                     |
| `ceph.backup.enabled`        | Enable Cinder Backup        | Whether or not enable cinder backup feature                                                                                  | `true`                       |
| `ceph.backup.poolName`       | Backup Pool Name            | The name of ceph pool used to store cinder volume backups                                                                    | `backups`                    |
| `ceph.backup.replicatedSize` | Pool Replicated Size        | For a pool based on raw copies, specify the number of copies. A size of 1 indicates no redundancy.                           | `3`                          |
| `ceph.backup.failureDomain`  | Pool Failure Domain         | The failure domain will spread the replicas of the data across different failure zones                                       | `host`                       |


### Ingress Parameters

| Name                   | Form title    | Description                                                                             | Value             |
| ---------------------- | ------------- | --------------------------------------------------------------------------------------- | ----------------- |
| `ingress.enabled`      | Ingress       | Whether or not create ingress for keystone service                                      | `true`            |
| `ingress.ingressClass` | Ingress Class | Ingress Class Name                                                                      | `openstack-nginx` |
| `ingress.path`         | Path Prefix   | Ingress will match the path prefix, and forward the matched request to keystone service | `volumev3`        |

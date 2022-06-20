
# glance

The chart used to deploy openstack glance project.

## TL;DR

```shell
$ helm repo add kolla-helm https://kungze.github.io/kolla-helm
$ helm install openstack-password kolla-helm/password
$ helm install openstack-dependency kolla-helm/openstack-dep
$ helm install openstack-keystone kolla-helm/keystone
$ helm install openstack-glance kolla-helm/glance --set ceph.enabled=false
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
| `serviceAccountName`   |                         | ServiceAccount name                                                      | `glance` |
| `enableLivenessProbe`  | Enable Liveness Probe   | Whether or not enable liveness probe                                     | `true`   |
| `enableReadinessProbe` | Enable Readliness Probe | Whether or not enable readiness probe                                    | `true`   |


### glance Config parameters

| Name                         | Form title                  | Description                                                                                         | Value         |
| ---------------------------- | --------------------------- | --------------------------------------------------------------------------------------------------- |-------------- |
| `db_database`                | Glance database             | The glance database name                                                                            | `glance`      |
| `db_username`                | Glance Database User        | The glance database user name                                                                       | `glance`      |
| `enabled_notification`       | Enable Notification         | Whether or not enable notification                                                                  | `false`       |
| `ceph.enabled`               | Enable Ceph                 | Whether or not enable ceph backend                                                                  | `true`        |
| `ceph.poolName`              | Pool Name                   | The ceph pool name which used to store the cinder volumes                                           | `volumes`     |
| `ceph.replicatedSize`        | Pool Replicated Size        | For a pool based on raw copies, specify the number of copies. A size of 1 indicates no redundancy.  | `3`           |
| `ceph.failureDomain`         | Pool Failure Domain         | The failure domain will spread the replicas of the data across different failure zones              | `host`        |
| `ceph.cephClusterNamespace`  | Rook Ceph Cluster Namespace | The k8s namespace of rook cephcluster                                                               | `rook-ceph`   |
| `ceph.cephClusterName`       | Rook Ceph Cluster Name      | The rook cephcluster name                                                                           | `rook-ceph`   |
| `ceph.cephClientName`        | Rook Ceph Client Name       | The name of rook ceph cephclient                                                                    | `glance`      |


### Ingress Parameters

| Name                   | Form title    | Description                                                                             | Value             |
| ---------------------- | ------------- | --------------------------------------------------------------------------------------- | ----------------- |
| `ingress.enabled`      | Ingress       | Whether or not create ingress for glance service                                        | `true`            |
| `ingress.ingressClass` | Ingress Class | Ingress Class Name                                                                      | `openstack-nginx` |
| `ingress.path`         | Path Prefix   | Ingress will match the path prefix, and forward the matched request to glance service   | `image`           |

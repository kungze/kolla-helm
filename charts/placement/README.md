
# placement

The chart used to deploy openstack placement project.

## TL;DR

```shell
$ helm repo add kolla-helm https://kungze.github.io/kolla-helm
$ helm install openstack-password kolla-helm/password
$ helm install openstack-dependency kolla-helm/openstack-dep
$ helm install openstack-keystone kolla-helm/keystone
$ helm install openstack-placement kolla-helm/placement 
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
| `replicaCount`         |                         | Number of placement replicas to deploy (requires ReadWriteMany PVC support) | `1`      |
| `serviceAccountName`   |                         | ServiceAccount name                                                      | `placement` |
| `enableLivenessProbe`  | Enable Liveness Probe   | Whether or not enable liveness probe                                     | `true`   |
| `enableReadinessProbe` | Enable Readliness Probe | Whether or not enable readiness probe                                    | `true`   |


### placement Config parameters

| Name                         | Form title                  | Description                                          | Value                        |
| ---------------------------- | --------------------------- | ---------------------------------------------------- | ---------------------------- |
| `db_database`                | Placement database          | The placement database name                          | `placement`                  |
| `db_username`                | Placement Database User     | The placement database user name                     | `placement`                  |
| `enabled_notification`       | Enable Notification         | Whether or not enable notification                   | `false`                      |


### Ingress Parameters

| Name                   | Form title    | Description                                                                             | Value             |
| ---------------------- | ------------- | --------------------------------------------------------------------------------------- | ----------------- |
| `ingress.enabled`      | Ingress       | Whether or not create ingress for placement service                                     | `true`            |
| `ingress.ingressClass` | Ingress Class | Ingress Class Name                                                                      | `openstack-nginx` |
| `ingress.path`         | Path Prefix   | Ingress will match the path prefix, and forward the matched request to keystone service | `placement`        |

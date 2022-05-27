# keystone

The chart used to deploy openstack keystone project

## TL;DR

```shell
$ helm repo add kolla-helm https://kungze.github.io/kolla-helm
$ helm install openstack-password kolla-helm/password
$ helm install openstack-dependency kolla-helm/openstack-dep
$ helm install openstack-keystone kolla-helm/keystone
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


### Image Parameters

| Name             | Form title        | Description                                     | Value                   |
| ---------------- | ----------------- | ----------------------------------------------- | ----------------------- |
| `imageRegistry`  | Image Registry    | The registry address of openstack kolla image   | `registry.aliyuncs.com` |
| `imageNamespace` | Image Namespace   | The registry namespace of openstack kolla image | `kolla-helm`            |
| `openstackTag`   | Openstack version | The openstack version                           | `yoga`                  |
| `pullPolicy`     | Pull Policy       | The image pull policy                           | `IfNotPresent`          |


### Keystone Config Parameters

| Name                            | Form title                | Description                       | Value      |
| ------------------------------- | ------------------------- | --------------------------------- | ---------- |
| `keystone_provider`             | Keystone Token Provider   | The keystone token provider       | `fernet`   |
| `keystone_expiration`           | Keystone Token expiration | The keystone token expiration     | `86400`    |
| `keystone_allow_expired_window` | Allow Expired Window      | The keystone allow expired window | `172800`   |
| `db_database`                   | Keystone database         | The keystone database name        | `keystone` |
| `db_username`                   | Keystone Database User    | The keystone database user name   | `keystone` |


### Admin Auth Parameters

| Name                        | Form title           | Description                       | Value       |
| --------------------------- | -------------------- | --------------------------------- | ----------- |
| `region_name`               | Region Name          | The openstack region name         | `RegionOne` |
| `admin_username`            | Admin Username       | The openstack admin user name     | `admin`     |
| `admin_project_name`        | Admin Project Name   | The openstack admin project name  | `admin`     |
| `admin_user_domain_name`    | Admin User Domain    | The domain name of admin user     | `default`   |
| `admin_project_domain_name` | Admin Project Domain | The openstack project domain name | `default`   |
| `admin_domain_id`           | Admin Domain Id      | The openstack admin domain id     | `default`   |


### Deployment Parameters

| Name                   | Form title              | Description                                    | Value          |
| ---------------------- | ----------------------- | ---------------------------------------------- | -------------- |
| `replicaCount`         | Replica Number          | Number of keystone replicas to deploy          | `1`            |
| `serviceAccountName`   | ServiceAccount name     | The k8s ServiceAccount name used by this chart | `keystone`     |
| `enableLivenessProbe`  | Enable Liveness Probe   | Whether or not enable liveness probe           | `true`         |
| `enableReadinessProbe` | Enable Readliness Probe | Whether or not enable readiness probe          | `true`         |
| `fernetRotateCron`     | Fernet Rotate Cron      | The keystone fernet token scheduler cron       | `* */12 * * *` |


### Ingress Parameters

| Name                   | Form title    | Description                                                                             | Value             |
| ---------------------- | ------------- | --------------------------------------------------------------------------------------- | ----------------- |
| `ingress.enabled`      | Ingress       | Whether or not create ingress for keystone service                                      | `true`            |
| `ingress.ingressClass` | Ingress Class | Ingress Class Name                                                                      | `openstack-nginx` |
| `ingress.path`         | Path Prefix   | Ingress will match the path prefix, and forward the matched request to keystone service | `identity`        |

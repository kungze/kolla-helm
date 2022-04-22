# Install the common dependency services for openstack

This chart will install [mariadb][mariadb], [rabbitmq][rabbitmq],
[memcached][memcached], [nginx-ingress-controller][nginx-ingress-controller] etc,
these are the dependency services of openstack projects. We wish all of openstack projects
can share same dependency services release, so this chart should be installed before install any
openstack projects.

## TL;DR

```base
$ helm repo add kolla-helm https://kungze.github.io/kolla-helm
$ helm install openstack-password kolla-helm/password
$ helm install openstack-dependency kolla-helm/openstack-dep
```

**NOTE:** The dependent chart ``password`` need to be installed in advance. For details, please
refer to the [docs](https://github.com/kungze/kolla-helm/blob/main/charts/password/README.md)

The connection informations of these services will be save in a ``secret`` named with this chart
release's name, like below:

```yaml
apiVersion: v1
data:
  database: b3BlbnN0YWNrLWRlcGVuZGVuY3ktbWFyaWFkYi50ZXN0LW9wZW5zdGFjay5zdmMuY2x1c3Rlci5sb2NhbDozMzA2
  memcache: b3BlbnN0YWNrLWRlcGVuZGVuY3ktbWVtY2FjaGVkLnRlc3Qtb3BlbnN0YWNrLnN2Yy5jbHVzdGVyLmxvY2FsOjExMjEx
  rabbitmq: b3BlbnN0YWNrLWRlcGVuZGVuY3ktcmFiYml0bXEudGVzdC1vcGVuc3RhY2suc3ZjLmNsdXN0ZXIubG9jYWw6NTY3Mg==
kind: Secret
metadata:
  annotations:
    meta.helm.sh/release-name: openstack-dependency
    meta.helm.sh/release-namespace: test-openstack
  creationTimestamp: "2022-04-22T06:37:55Z"
  labels:
    app.kubernetes.io/managed-by: Helm
  name: openstack-dependency
  namespace: default
  resourceVersion: "12731688"
  uid: 3450ccb0-e20f-4a2c-a2a1-9765038742c7
type: Opaque
```

## Parameters

### Global Parameters

| Name                  | Form title           | Description                                    | Value           |
| --------------------- | -------------------- | ---------------------------------------------- | --------------- |
| `clusterDomainSuffix` | Cluser domain suffix | The domain suffix of of the current k8s cluser | `cluster.local` |


### Database Parameters

| Name                                         | Form title             | Description                                                                                           | Value                |
| -------------------------------------------- | ---------------------- | ----------------------------------------------------------------------------------------------------- | -------------------- |
| `mariadb.enabled`                            | Mariadb                | Whether or not deploy mariadb database                                                                | `true`               |
| `mariadb.architecture`                       | Architecture           | MariaDB architecture (`standalone` or `replication`)                                                  | `standalone`         |
| `mariadb.auth.existingSecret`                | Password chart release | Use the secret of the kolla-helm/charts/password release to provide the password for mariadb instance | `openstack-password` |
| `mariadb.primary.persistence.storageClass`   | Primary Storage Class  | Persistent Volume storage class                                                                       | `""`                 |
| `mariadb.primary.persistence.size`           | Primary Storage Size   | Persistent Volume size                                                                                | `8Gi`                |
| `mariadb.secondary.replicaCount`             | Replica Number         | Number of MariaDB secondary replicas                                                                  | `1`                  |
| `mariadb.secondary.persistence.storageClass` | Replica Storage Class  | MariaDB secondary persistent volume storage Class                                                     | `""`                 |
| `mariadb.secondary.persistence.size`         | Replica Storage Size   | MariaDB secondary persistent volume size                                                              | `8Gi`                |


### RabbitMQ parameters

| Name                                   | Form title             | Description                                                                                            | Value                |
| -------------------------------------- | ---------------------- | ------------------------------------------------------------------------------------------------------ | -------------------- |
| `rabbitmq.enabled`                     | Rabbitmq               | Whether or not deploy rabbitmq                                                                         | `true`               |
| `rabbitmq.auth.username`               | Username               | RabbitMQ username                                                                                      | `openstack`          |
| `rabbitmq.auth.existingPasswordSecret` | Password chart release | Use the secret of the kolla-helm/charts/password release to provide the password for rabbitmq instance | `openstack-password` |
| `rabbitmq.persistence.storageClass`    | Storage Class          | Persistent Volume storage class                                                                        | `""`                 |
| `rabbitmq.persistence.size`            | Storage Size           | Persistent Volume size                                                                                 | `8Gi`                |


### Memcached parameters

| Name                     | Form title | Description                     | Value   |
| ------------------------ | ---------- | ------------------------------- | ------- |
| `memcached.enabled`      | Memcached  | Whether or not deploy memcached | `true`  |
| `memcached.service.port` |            | Memcached service port          | `11211` |


### Nginx-ingress-controller  parameters

| Name                                                   | Form title               | Description                                                                      | Value       |
| ------------------------------------------------------ | ------------------------ | -------------------------------------------------------------------------------- | ----------- |
| `nginx-ingress-controller.enabled`                     | Nginx-ingress-controller | Whether or not deploy nginx-ingress-controller                                   | `true`      |
| `nginx-ingress-controller.defaultBackend.service.type` |                          | Kubernetes Service type for default backend                                      | `ClusterIP` |
| `nginx-ingress-controller.kind`                        |                          | Install as DaemonSet                                                             | `DaemonSet` |
| `nginx-ingress-controller.daemonset.useHostPort`       |                          | If `kind` is `DaemonSet`, this will enable `hostPort` for `TCP/80` and `TCP/443` | `true`      |


[mariadb]: https://github.com/bitnami/charts/tree/master/bitnami/mariadb
[rabbitmq]: https://github.com/bitnami/charts/tree/master/bitnami/rabbitmq
[memcached]: https://github.com/bitnami/charts/tree/master/bitnami/memcached
[nginx-ingress-controller]: https://github.com/bitnami/charts/tree/master/bitnami/nginx-ingress-controller

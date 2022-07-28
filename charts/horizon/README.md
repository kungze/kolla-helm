# horizon

The chart used to deploy openstack horizon project

## TL;DR

```shell
$ helm repo add kolla-helm https://kungze.github.io/kolla-helm
$ helm install horizon kolla-helm/horizon
```

## Parameters

### Cluster Paramters

| Name                    | Form title            | Description                                  | Value           |
| ----------------------- | --------------------- | -------------------------------------------- | --------------- |
| `cluster_domain_suffix` | Cluster Domain Suffix | The doamin suffix of the current k8s cluster | `cluster.local` |


### Image Parameters

| Name             | Form title        | Description                                     | Value          |
| ---------------- | ----------------- | ----------------------------------------------- | -------------- |
| `imageRegistry`  | Image Registry    | The registry address of openstack kolla image   | `docker.io`    |
| `imageNamespace` | Image Namespace   | The registry namespace of openstack kolla image | `kolla`        |
| `openstackTag`   | Openstack version | The openstack version                           | `yoga`         |
| `pullPolicy`     | Pull Policy       | The image pull policy                           | `IfNotPresent` |


### Deployment Parameters

| Name                   | Form title              | Description                                                              | Value     |
| ---------------------- | ----------------------- | ------------------------------------------------------------------------ | --------- |
| `replicaCount`         |                         | Number of cinder replicas to deploy (requires ReadWriteMany PVC support) | `1`       |
| `serviceAccountName`   |                         | ServiceAccount name                                                      | `horizon` |
| `enableLivenessProbe`  | Enable Liveness Probe   | Whether or not enable liveness probe                                     | `true`    |
| `enableReadinessProbe` | Enable Readliness Probe | Whether or not enable readiness probe                                    | `true`    |

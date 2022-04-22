# keystone

keystone charts 安装 openstack keystone service.  
keystone charts 依赖 [openstack-dep charts](https://github.com/kungze/charts/tree/main/charts/openstack-dep).  
如果 openstack-dep charts 在 k8s 环境中已经安装，可从 openstack-dep 生成的 secrets 中读取 rabbitmq、mariadb、memcached 的 URL 信息，配置到values.yaml中。

## 快速部署

```
helm repo add kungze https://kungze.github.io/charts
helm install keystone kungze/keystone
```

部署完成之后会生成提示信息

```
** 请耐心等待 chart 部署完成 **你可以通过 openstack cli 访问 keystone 服务

设置环境变量(示例如下)

    export OS_USERNAME=$(kubectl get secret --namespace "cinder" keystone-admin-secret -o jsonpath="{.data.OS_USERNAME}" | base64 --decode)
    export OS_PROJECT_DOMAIN_NAME=$(kubectl get secret --namespace "cinder" keystone-admin-secret -o jsonpath="{.data.OS_PROJECT_DOMAIN_NAME}" | base64 --decode)
    export OS_USER_DOMAIN_NAME=$(kubectl get secret --namespace "cinder" keystone-admin-secret -o jsonpath="{.data.OS_USER_DOMAIN_NAME}" | base64 --decode)
    export OS_PROJECT_NAME=$(kubectl get secret --namespace "cinder" keystone-admin-secret -o jsonpath="{.data.OS_PROJECT_NAME}" | base64 --decode)
    export OS_REGION_NAME=$(kubectl get secret --namespace "cinder" keystone-admin-secret -o jsonpath="{.data.OS_REGION_NAME}" | base64 --decode)
    export OS_IDENTITY_API_VERSION=$(kubectl get secret --namespace "cinder" keystone-admin-secret -o jsonpath="{.data.OS_IDENTITY_API_VERSION}" | base64 --decode)
    export OS_PASSWORD=$(kubectl get --namespace cinder -o jsonpath="{.data.keystone-admin-password}" secrets openstack-password | base64 --decode)
    export OS_AUTH_URL=http://keystone.cinder.svc.cluster.local/v3
```

## Parameters

### Global parameters

| Name                   | Form title | Description                                  | Value          |
| ---------------------- | ---------- | -------------------------------------------- | -------------- |
| `global.imageRegistry` |            | Global Docker image registry                 | `docker.io`    |
| `global.storageClass`  |            | Global StorageClass for Persistent Volume(s) | `""`           |
| `global.imageTag`      |            | Global docker image tag                      | `xena`         |
| `global.pullPolicy`    |            | Global image pull policy                     | `IfNotPresent` |


### Common parameters

| Name                                 | Form title | Description                                                                | Value      |
| ------------------------------------ | ---------- | -------------------------------------------------------------------------- | ---------- |
| `replicaCount`                       |            | Number of keystone replicas to deploy (requires ReadWriteMany PVC support) | `1`        |
| `serviceAccountName`                 |            | ServiceAccount name                                                        | `keystone` |
| `resources.limits`                   |            | The resources limits for the Controller container                          | `{}`       |
| `resources.requests`                 |            | The requested resources for the Controller container                       | `{}`       |
| `podSecurityContext.enabled`         |            | Enabled keystone pods' Security Context                                    | `true`     |
| `podSecurityContext.runAsUser`       |            | Set keystone container's Security Context runAsUser                        | `0`        |
| `containerSecurityContext.enabled`   |            | Enabled keystone containers' Security Context                              | `true`     |
| `containerSecurityContext.runAsUser` |            | Set keystone container's Security Context runAsUser                        | `0`        |
| `livenessProbe.enabled`              |            | Enable livenessProbe                                                       | `true`     |
| `livenessProbe.httpGet.path`         |            | Request path for livenessProbe                                             | `/v3/`     |
| `livenessProbe.httpGet.port`         |            | Port for livenessProbe                                                     | `5000`     |
| `livenessProbe.httpGet.scheme`       |            | Scheme for livenessProbe                                                   | `HTTP`     |
| `livenessProbe.initialDelaySeconds`  |            | Initial delay seconds for livenessProbe                                    | `50`       |
| `livenessProbe.periodSeconds`        |            | Period seconds for livenessProbe                                           | `60`       |
| `livenessProbe.timeoutSeconds`       |            | Timeout seconds for livenessProbe                                          | `15`       |
| `livenessProbe.failureThreshold`     |            | Failure threshold for livenessProbe                                        | `3`        |
| `livenessProbe.successThreshold`     |            | Success threshold for livenessProbe                                        | `1`        |
| `readinessProbe.enabled`             |            | Enable readinessProbe                                                      | `true`     |
| `readinessProbe.httpGet.path`        |            | Request path for readinessProbe                                            | `/v3/`     |
| `readinessProbe.httpGet.port`        |            | Port for readinessProbe                                                    | `5000`     |
| `readinessProbe.httpGet.scheme`      |            | Scheme for readinessProbe                                                  | `HTTP`     |
| `readinessProbe.initialDelaySeconds` |            | Initial delay seconds for readinessProbe                                   | `50`       |
| `readinessProbe.periodSeconds`       |            | Period seconds for readinessProbe                                          | `60`       |
| `readinessProbe.timeoutSeconds`      |            | Timeout seconds for readinessProbe                                         | `15`       |
| `readinessProbe.failureThreshold`    |            | Failure threshold for readinessProbe                                       | `3`        |
| `readinessProbe.successThreshold`    |            | Success threshold for readinessProbe                                       | `1`        |
| `customLivenessProbe`                |            | Override default liveness probe                                            | `{}`       |
| `customReadinessProbe`               |            | Override default readiness probe                                           | `{}`       |
| `lifecycle`                          |            | LifecycleHooks to set additional configuration at startup                  | `""`       |


### Keystone Image parameters

| Name                            | Form title | Description                                       | Value                               |
| ------------------------------- | ---------- | ------------------------------------------------- | ----------------------------------- |
| `image.keystoneAPI.repository`  |            | Moodle image repository                           | `kolla/ubuntu-binary-keystone`      |
| `image.dbSync.repository`       |            | Moodle image repository                           | `kolla/ubuntu-binary-keystone`      |
| `image.kollaToolbox.repository` |            | Moodle image repository                           | `kolla/ubuntu-binary-kolla-toolbox` |
| `image.entrypoint.registry`     |            | Moodle image registry                             | `quay.io`                           |
| `image.entrypoint.repository`   |            | Moodle image repository                           | `airshipit/kubernetes-entrypoint`   |
| `image.entrypoint.tag`          |            | Moodle image tag (immutable tags are recommended) | `v1.0.0`                            |


### Traffic Exposure Parameters

| Name                                | Form title | Description                                                                   | Value                    |
| ----------------------------------- | ---------- | ----------------------------------------------------------------------------- | ------------------------ |
| `service.type`                      |            | Kubernetes Service type                                                       | `ClusterIP`              |
| `service.publicService.name`        |            | keystone public svc name                                                      | `keystone-api`           |
| `service.publicService.port`        |            | keystone public svc port                                                      | `5000`                   |
| `service.publicService.portname`    |            | keystone public svc port name                                                 | `ks-pub`                 |
| `service.internalService.name`      |            | keystone internal svc name                                                    | `keystone`               |
| `service.internalService.httpPort`  |            | keystone internal svc http port                                               | `80`                     |
| `service.internalService.httpName`  |            | keystone internal svc http port name                                          | `http`                   |
| `service.internalService.httpsPort` |            | keystone internal svc https port                                              | `443`                    |
| `service.internalService.httpsName` |            | keystone internal svc https port name                                         | `https`                  |
| `service.nodePorts.http`            |            | Node port for HTTP                                                            | `""`                     |
| `service.nodePorts.https`           |            | Node port for HTTPS                                                           | `""`                     |
| `service.clusterIP`                 |            | Cluster internal IP of the service                                            | `""`                     |
| `service.loadBalancerIP`            |            | keystone service Load Balancer IP                                             | `""`                     |
| `service.externalTrafficPolicy`     |            | keystone service external traffic policy                                      | `Cluster`                |
| `ingress.enabled`                   |            | Enable ingress record generation for keystone                                 | `true`                   |
| `ingress.pathType`                  |            | Ingress path type                                                             | `ImplementationSpecific` |
| `ingress.apiVersion`                |            | Force Ingress API version (automatically detected if not set)                 | `""`                     |
| `ingress.ingressClassName`          |            | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+) | `nginx`                  |
| `ingress.hostname`                  |            | Default host for the ingress record                                           | `keystone`               |
| `ingress.path`                      |            | Default path for the ingress record                                           | `/`                      |


### openstack dependency env

| Name                                    | Form title           | Description                                       | Value                 |
| --------------------------------------- | -------------------- | ------------------------------------------------- | --------------------- |
| `openstack-dep.enabled`                 | 安裝 openstack-dep     | 安装openstack依赖环境，包含mariadb;rabbitmq;memcached 等... | `true`                |
| `openstack-dep.connInfoSecret`          | ConnInfo secret name | openstack 依赖环境中生成服务URL得 secret 名称                 | `openstack-conn-info` |
| `openstack-dep.passwordSecretName`      | Password secret name | openstack 依赖环境中自动生成服务相关密码得 secret 名称              | `openstack-password`  |
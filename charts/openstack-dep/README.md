# Install the common dependency software for openstack

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

[mariadb]: https://github.com/bitnami/charts/tree/master/bitnami/mariadb
[rabbitmq]: https://github.com/bitnami/charts/tree/master/bitnami/rabbitmq
[memcached]: https://github.com/bitnami/charts/tree/master/bitnami/memcached
[nginx-ingress-controller]: https://github.com/bitnami/charts/tree/master/bitnami/nginx-ingress-controller

# kolla-helm

Deploy openstack on k8s cluster by helm charts.

## Q&A

* Q: What's the implication of the name ``kolla-helm``?

    A: ``kolla`` means that the openstack related container images are builded by openstack [openstack kolla project](https://github.com/openstack/kolla). ``helm`` represent [helm chart](https://helm.sh/).

* Q: What's the difference with [openstack-helm](https://github.com/openstack/openstack-helm)?

    A: ``openstack-helm`` contains all openstack projects and the dependencies of these projects, it is tremendous and complicated. Moreover, ``openstack-helm`` charts still depend on helm v2 api. The aim of ``kolla-helm`` is thart provide a lightweight and easy-to-use solution to deploy openstack on k8s cluster.

## Quickstart

* Add kolla-helm charts repository

```shell
helm repo add kolla-helm https://kungze.github.io/kolla-helm
helm repo update
```

* Install the fundamental charts

```shell
helm install openstack-password kolla-helm/password
helm install openstack-dependency kolla-helm/openstack-dep
```

``kolla-helm/password`` will random generate some password. The subsequent charts will use these passwords to create user (mariadb, rabbitmq, keystone).
``kolla-helm/openstack-dep`` will install the dependent software, contains: mariadb, rabbitmq, memcached and nginx-ingress-controller.

* Install openstack keystone

```shell
helm install openstack-keystone kolla-helm/keystone --set passwordRelease=openstack-password,openstackDepRelease=openstack-dependency
```

The parameters ``passwordRelease`` and  ``openstackDepRelease`` are required, ``passwordRelease`` used to specify the release of ``kolla-helm/password`` chart, ``openstackDepRelease`` used to specify the release of ``kolla-helm/openstack-dep``.

* Install openstack cinder

```shell
helm install openstack-cinder kolla-helm/cinder --set ceph.enabled=false,passwordRelease=openstack-password,openstackDepRelease=openstack-dependency,keystoneRelease=openstack-keystone
```

Because of cinder depend on keystone, so the parameter ``keystoneRelease`` is required, it used to specify the release of ``kolla-helm/keystone``. Note: The cinder's ceph backend dependent on [rook ceph cluster](https://rook.io/docs/rook/v1.9/Getting-Started/intro/), if you want enable ceph backend, you need to use rook manage the ceph cluster or create a ceph cluster in advance.

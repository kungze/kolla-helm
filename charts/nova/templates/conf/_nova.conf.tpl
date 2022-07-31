[DEFAULT]
log_dir = /var/log/kolla/nova
state_path = /var/lib/nova
enabled_apis = osapi_compute
compute_driver = libvirt.LibvirtDriver
transport_url = rabbit://openstack:rabbitmq_password_placeholder@rabbitmq_endpoint_placeholder
[api]
auth_strategy = keystone

[oslo_concurrency]
lock_path = $state_path/tmp

[api_database]
connection = mysql+pymysql://nova:database_password_placeholder@database_endpoint_placeholder/nova_api

[database]
connection = mysql+pymysql://nova:database_password_placeholder@database_endpoint_placeholder/nova

[glance]
api_servers = glance_endpoint_placeholder

[cinder]
catalog_info = volumev3:cinderv3:internalURL
os_region_name = RegionOne
auth_url = keystone_endpoint_placeholder
auth_type = password
project_domain_name = Default
user_domain_id = default
project_name = service
username = cinder
password = cinder_password_placeholder
cafile =

[neutron]
service_metadata_proxy = true
auth_url = keystone_endpoint_placeholder
auth_type = password
project_domain_name = Default
user_domain_id = default
project_name = service
username = neutron
password = neutron_password_placeholder
region_name = RegionOne
valid_interfaces = internal
cafile =


[keystone_authtoken]
www_authenticate_uri = keystone_endpoint_placeholder
auth_url = keystone_endpoint_placeholder
auth_type = password
project_domain_id = default
user_domain_id = default
project_name = service
username = nova
password = keystone_password_placeholder
memcached_servers = memcache_endpoint_placeholder

[placement]
auth_url = keystone_endpoint_placeholder
os_region_name = RegionOne
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = placement
password = placement_password_placeholder

[wsgi]
api_paste_config = /etc/nova/api-paste.ini

[libvirt]
virt_type = kvm
{{- if .Values.ceph.enabled }}
images_type = rbd
images_rbd_pool = compute
images_rbd_ceph_conf = /etc/ceph/ceph.conf
rbd_user = {{ .Values.ceph.cephClientName }}
rbd_secret_uuid = rbd_secret_uuid_palceholder
{{- end }}

[scheduler]
discover_hosts_in_cells_interval = 120

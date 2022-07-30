[DEFAULT]
debug = False
log_dir = /var/log/kolla/neutron
use_stderr = False
bind_host = 0.0.0.0
bind_port = 9696
{{- if .Values.neutron_linuxbridge_agent.enabled }}
interface_driver = linuxbridge
{{- else if .Values.neutron_openvswitch_agent.enabled }}
interface_driver = openvswitch
{{- end }}
allow_overlapping_ips = true
notify_nova_on_port_status_changes = True
notify_nova_on_port_data_changes = True
core_plugin = ml2
service_plugins = {{ .Values.neutron_server.service_plugins }}
transport_url = rabbit://openstack:rabbitmq_password_placeholder@rabbitmq_endpoint_placeholder
ipam_driver = internal
metadata_proxy_socket = /var/lib/neutron/kolla/metadata_proxy

[oslo_middleware]
enable_proxy_headers_parsing = True

[oslo_concurrency]
lock_path = /var/lib/neutron/tmp

[agent]
root_helper = sudo neutron-rootwrap /etc/neutron/rootwrap.conf

[database]
connection = mysql+pymysql://neutron:database_password_placeholder@database_endpoint_placeholder/neutron
connection_recycle_time = 10
max_pool_size = 1
max_retries = -1

[keystone_authtoken]
www_authenticate_uri = keystone_endpoint_placeholder
auth_url = keystone_endpoint_placeholder
auth_type = password
project_domain_id = default
user_domain_id = default
project_name = service
username = neutron
password = keystone_password_placeholder
memcached_servers = memcache_endpoint_placeholder
memcache_use_advanced_pool = True

[privsep]
helper_command=sudo neutron-rootwrap /etc/neutron/rootwrap.conf privsep-helper

[nova]
auth_url = keystone_endpoint_placeholder
auth_type = password
project_domain_name = default
user_domain_name = default
region_name = RegionOne
project_name = service
username = nova
password = nova_password_placeholder


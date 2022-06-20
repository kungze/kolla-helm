[DEFAULT]
debug = False
log_file = /var/log/kolla/glance/glance-api.log
use_forwarded_for = true
bind_host = 0.0.0.0
bind_port = 9292
workers = 5
show_multiple_locations = True
transport_url = rabbit://openstack:rabbitmq_password_placeholder@rabbitmq_endpoint_placeholder
{{- if .Values.ceph.enabled }}
enabled_backends = rbd:rbd
{{- end }}

[database]
connection = mysql+pymysql://glance:database_password_placeholder@database_endpoint_placeholder/glance
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
username = glance
password = keystone_password_placeholder
memcached_servers = memcache_endpoint_placeholder

[paste_deploy]
flavor = keystone

[glance_store]
{{- if .Values.ceph.enabled }}
default_backend = rbd
{{- else }}
default_backend = file
{{- end }}

{{- if .Values.ceph.enabled }}
[rbd]
rbd_store_user = {{ .Values.ceph.cephClientName }}
rbd_store_pool = {{ .Values.ceph.poolName }}
rbd_store_chunk_size = 8
{{- else }}
[file]
filesystem_store_datadir = /var/lib/glance/images/
{{- end }}


[os_glance_tasks_store]
filesystem_store_datadir = /var/lib/glance/tasks_work_dir

[os_glance_staging_store]
filesystem_store_datadir = /var/lib/glance/staging

[oslo_middleware]
enable_proxy_headers_parsing = True

[oslo_messaging_notifications]
transport_url = rabbit://openstack:rabbitmq_password_placeholder@rabbitmq_endpoint_placeholder
driver = noop

[image_import_opts]
image_import_plugins = [image_conversion]

[taskflow_executor]
conversion_format = raw

[cors]
allowed_origin = *
allow_headers = Content-MD5,X-Image-Meta-Checksum,X-Storage-Token,Accept-Encoding,X-Auth-Token,X-Identity-Status,X-Roles,X-Service-Catalog,X-User-Id,X-Tenant-Id,X-OpenStack-Request-ID,Authorization,Current-Project,Current-User,Operation-Code,Region-Code


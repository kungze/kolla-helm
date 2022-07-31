[DEFAULT]
debug = False
use_forwarded_for = true
use_stderr = False
log_dir = /var/log/kolla/cinder
osapi_volume_workers = 5
volume_name_template = volume-%s
volumes_dir = /var/lib/cinder/volumes
os_region_name = region_placeholder
glance_api_servers = glance_endpoint_placeholder
glance_api_version = 2

{{- if and .Values.lvm.enabled .Values.ceph.enabled }}
enabled_backends = {{ printf "%s,%s" (.Values.lvm.volume_type) (.Values.ceph.volume_type) }}
default_volume_type = {{ .Values.ceph.volume_type }}
{{- else if .Values.lvm.enabled }}
enabled_backends = {{ .Values.lvm.volume_type }}
default_volume_type = {{ .Values.lvm.volume_type }}
{{- else if .Values.ceph.enabled }}
enabled_backends = {{ .Values.ceph.volume_type }}
default_volume_type = {{ .Values.ceph.volume_type }}
{{- end }}

{{- if and .Values.ceph.enabled .Values.ceph.backup.enabled }}
backup_driver = cinder.backup.drivers.ceph.CephBackupDriver
backup_ceph_conf = /etc/ceph/ceph.conf
backup_ceph_user = {{ .Values.ceph.cephClientName }}
backup_ceph_chunk_size = 134217728
backup_ceph_pool = {{ .Values.ceph.backup.poolName }}
backup_ceph_stripe_unit = 0
backup_ceph_stripe_count = 0
restore_discard_excess_bytes = true
{{- end }}

osapi_volume_listen = 0.0.0.0
api_paste_config = /etc/cinder/api-paste.ini
auth_strategy = keystone
transport_url = rabbit://openstack:rabbitmq_password_placeholder@rabbitmq_endpoint_placeholder
enable_force_upload = True
verify_glance_signatures = disabled
random_select_backend = True

{{- if .Values.ceph.enabled }}
random_select_backend = True
{{- end }}

[oslo_messaging_notifications]
{{- if .Values.enabled_notification }}
transport_url = rabbit://openstack:rabbitmq_password_placeholder@rabbitmq_endpoint_placeholder
driver = messagingv2
topics = notifications
{{- else }}
driver = noop
{{- end }}

[oslo_middleware]
enable_proxy_headers_parsing = True

[database]
connection = mysql+pymysql://cinder:database_password_placeholder@database_endpoint_placeholder/cinder
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
username = cinder
password = keystone_password_placeholder
memcached_servers = memcache_endpoint_placeholder

[oslo_concurrency]
lock_path = /var/lib/cinder/tmp

[privsep_entrypoint]
helper_command = sudo cinder-rootwrap /etc/cinder/rootwrap.conf privsep-helper --config-file /etc/cinder/cinder.conf

{{- if .Values.ceph.enabled }}
[{{ .Values.ceph.volume_type }}]
volume_driver = cinder.volume.drivers.rbd.RBDDriver
volume_backend_name = {{ .Values.ceph.volume_type }}
rbd_pool = {{ .Values.ceph.poolName }}
rbd_ceph_conf = /etc/ceph/ceph.conf
rbd_flatten_volume_from_snapshot = false
rbd_max_clone_depth = 5
rbd_store_chunk_size = 4
rados_connect_timeout = 5
rbd_user = {{ .Values.ceph.cephClientName }}
rbd_secret_uuid = rbd_secret_uuid_palceholder
report_discard_supported = True
image_upload_use_cinder_backend = False
{{- end }}

{{- if .Values.lvm.enabled }}
[{{ .Values.lvm.volume_type }}]
volume_group = {{ .Values.lvm.vg_name }}
volume_driver = cinder.volume.drivers.lvm.LVMVolumeDriver
volume_backend_name = {{ .Values.lvm.volume_type }}
target_helper = {{ .Values.lvm.lvm_target_helper }}
target_protocol = iscsi
lvm_type = default
{{- end }}

[DEFAULT]
debug = False
log_file = /var/log/kolla/keystone/keystone.log
use_stderr = True

[oslo_middleware]
enable_proxy_headers_parsing = True

[database]
connection = mysql+pymysql://keystone:database_password_placeholder@database_endpoint_placeholder/keystone
connection_recycle_time = 10
max_pool_size = 1
max_retries = -1

[token]
revoke_by_id = False
provider = {{ .Values.keystone_provider }}
expiration = {{ .Values.keystone_expiration }}
allow_expired_window = {{ .Values.keystone_allow_expired_window }}

[fernet_tokens]
max_active_keys = 3

[cache]
backend = oslo_cache.memcache_pool
enabled = True
memcache_servers = memcache_endpoint_placeholder

[DEFAULT]
debug = False
log_dir = /var/log/kolla/placement
state_path = /var/lib/placement

[api]
auth_strategy = keystone

[keystone_authtoken]
www_authenticate_uri = keystone_endpoint_placeholder
auth_url = keystone_endpoint_placeholder
auth_type = password
project_domain_id = default
user_domain_id = default
project_name = service
username = placement
password = keystone_password_placeholder
memcached_servers = memcache_endpoint_placeholder

[placement_database]
connection = mysql+pymysql://placement:database_password_placeholder@database_endpoint_placeholder/placement
connection_recycle_time = 10
max_overflow = 1000
max_pool_size = 1
max_retries = -1

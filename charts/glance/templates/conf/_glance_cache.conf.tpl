[DEFAULT]

debug = True
log_file = /var/log/kolla/glance/glance-cache.log

image_cache_max_size = 10737418240
image_cache_dir = /var/lib/glance/image-cache

auth_url = keystone_endpoint_placeholder
admin_password = keystone_password_placeholder
admin_user = glance
admin_tenant_name = default

filesystem_store_datadir = /var/lib/glance/images/

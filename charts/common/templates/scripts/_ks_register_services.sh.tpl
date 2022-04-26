{{- define "common.scripts.ks_register_services" -}}
#!/bin/bash
set -ex

/opt/ansible/bin/ansible localhost -m os_keystone_service \
    -a "name=$SERVICE_NAME service_type=$SERVICE_TYPE region_name=$OS_REGION_NAME"
/opt/ansible/bin/ansible localhost -m os_keystone_endpoint \
    -a "service=$SERVICE_NAME url=$ADMIN_URL endpoint_interface=admin region=$OS_REGION_NAME region_name=$OS_REGION_NAME"
/opt/ansible/bin/ansible localhost -m os_keystone_endpoint \
    -a "service=$SERVICE_NAME url=$INTERNAL_URL endpoint_interface=internal region=$OS_REGION_NAME region_name=$OS_REGION_NAME"
/opt/ansible/bin/ansible localhost -m os_keystone_endpoint \
    -a "service=$SERVICE_NAME url=$PUBLIC_URL endpoint_interface=public region=$OS_REGION_NAME region_name=$OS_REGION_NAME"
{{- end -}}

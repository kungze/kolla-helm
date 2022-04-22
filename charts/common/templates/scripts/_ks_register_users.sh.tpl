{{- define "common.scripts.ks_register_users" -}}
#!/bin/bash
set -ex
/opt/ansible/bin/ansible localhost -m os_project -a "name=service domain=default region_name=$OS_REGION_NAME"
/opt/ansible/bin/ansible localhost -m os_user -a "default_project=service name=$USER_NAME password=$USER_PASSWORD domain=default region_name=$OS_REGION_NAME"
/opt/ansible/bin/ansible localhost -m os_keystone_role -a "name=admin region_name=$OS_REGION_NAME"
/opt/ansible/bin/ansible localhost -m os_user_role -a "user=$USER_NAME role=admin project=service domain=default region_name=$OS_REGION_NAME"
{{- end -}}

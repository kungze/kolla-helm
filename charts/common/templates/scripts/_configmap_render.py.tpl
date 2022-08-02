{{- define "common.scripts.configmap_render" -}}
#!/usr/bin/env python
import logging
import os
import requests
import sys
import tempfile

NAMESPACE = os.environ['KUBERNETES_NAMESPACE']
KUBE_HOST = None
KUBE_CERT = '/var/run/secrets/kubernetes.io/serviceaccount/ca.crt'
KUBE_TOKEN = None
DB_PASSWORD = os.getenv('DB_PASSWORD', None)
RABBITMQ_PASSWORD = os.getenv('RABBITMQ_PASSWORD', None)
OS_REGION = os.getenv('OS_REGION', None)
KEYSTONE_ENDPOINT = os.getenv('KEYSTONE_ENDPOINT', None)
KEYSTONE_PASSWORD = os.getenv('KEYSTONE_PASSWORD', None)
GLANCE_ENDPOINT = os.getenv('GLANCE_ENDPOINT', None)
GLANCE_PASSWORD = os.getenv('GLANCE_PASSWORD', None)
CINDER_PASSWORD = os.getenv('CINDER_PASSWORD', None)
NEUTRON_PASSWORD = os.getenv('NEUTRON_PASSWORD', None)
NOVA_PASSWORD = os.getenv('NOVA_PASSWORD', None)
PLACEMENT_PASSWORD = os.getenv('PLACEMENT_PASSWORD', None)
DATABASE_ENDPOINT = os.getenv('DATABASE_ENDPOINT', None)
RABBITMQ_ENDPOINT = os.getenv('RABBITMQ_ENDPOINT', None)
MEMCACHE_ENDPOINT = os.getenv('MEMCACHE_ENDPOINT', None)
CONF_FILE_NAME = os.getenv('CONF_FILE_NAME', None)
CONFIG_MAP_NAME = os.getenv('CONFIG_MAP_NAME', None)
AUTH_URL = os.getenv('AUTH_URL', None)
RBD_SECRET_UUID = os.getenv('RBD_SECRET_UUID', '')
NOVNCPROXY_URL = os.getenv('NOVNCPROXY_URL', None)
SPICEPROXY_URL = os.getenv('SPICEPROXY_URL', None)

LOG_DATEFMT = "%Y-%m-%d %H:%M:%S"
LOG_FORMAT = "%(asctime)s.%(msecs)03d - %(levelname)s - %(message)s"
logging.basicConfig(format=LOG_FORMAT, datefmt=LOG_DATEFMT)
LOG = logging.getLogger(__name__)
LOG.setLevel(logging.INFO)


def read_kube_config():
    global KUBE_HOST, KUBE_TOKEN
    KUBE_HOST = "https://%s:%s" % ('kubernetes.default',
                                    os.environ['KUBERNETES_SERVICE_PORT'])
    with open('/var/run/secrets/kubernetes.io/serviceaccount/token', 'r') as f:
        KUBE_TOKEN = f.read()


def get_configmap_definition(name):
    url = '%s/api/v1/namespaces/%s/configmaps/%s' % (KUBE_HOST, NAMESPACE, name)
    LOG.info('Request kubernetes configmaps url %s.', url)
    resp = requests.get(url,
                        headers={'Authorization': 'Bearer %s' % KUBE_TOKEN},
                        verify=KUBE_CERT)
    if resp.status_code != 200:
        LOG.error('Cannot get configmap %s.', name)
        LOG.error(resp.text)
        return None
    return resp.json()


def update_configmap(name, configmap):
    url = '%s/api/v1/namespaces/%s/configmaps/%s' % (KUBE_HOST, NAMESPACE, name)
    resp = requests.put(url,
                        json=configmap,
                        headers={'Authorization': 'Bearer %s' % KUBE_TOKEN},
                        verify=KUBE_CERT)
    if resp.status_code != 200:
        LOG.error('Cannot update configmap %s.', name)
        LOG.error(resp.text)
        return False
    return True


def update_connection_fields(content):
    tmp = tempfile.NamedTemporaryFile(prefix='tmp', suffix='.ini', dir='/tmp')
    LOG.info('Start update configmap file data %s.', CONF_FILE_NAME)
    with open(tmp.name, 'w') as f:
        f.seek(0, 0)
        for line in content.split("\n"):
            if "keystone_password_placeholder" in line:
                line = line.replace("keystone_password_placeholder", KEYSTONE_PASSWORD)
            if "database_password_placeholder" in line:
                line = line.replace("database_password_placeholder", DB_PASSWORD)
            if "rabbitmq_password_placeholder" in line:
                line = line.replace("rabbitmq_password_placeholder", RABBITMQ_PASSWORD)
            if "glance_password_placeholder" in line:
                line = line.replace("glance_password_placeholder", GLANCE_PASSWORD)
            if "cinder_password_placeholder" in line:
                line = line.replace("cinder_password_placeholder", CINDER_PASSWORD)
            if "neutron_password_placeholder" in line:
                line = line.replace("neutron_password_placeholder", NEUTRON_PASSWORD)
            if "nova_password_placeholder" in line:
                line = line.replace("nova_password_placeholder", NOVA_PASSWORD)
            if "placement_password_placeholder" in line:
                line = line.replace("placement_password_placeholder", PLACEMENT_PASSWORD)
            if "keystone_endpoint_placeholder" in line:
                line = line.replace("keystone_endpoint_placeholder", KEYSTONE_ENDPOINT)
            if "database_endpoint_placeholder" in line:
                line = line.replace("database_endpoint_placeholder", DATABASE_ENDPOINT)
            if "memcache_endpoint_placeholder" in line:
                line = line.replace("memcache_endpoint_placeholder", MEMCACHE_ENDPOINT)
            if "rabbitmq_endpoint_placeholder" in line:
                line = line.replace("rabbitmq_endpoint_placeholder", RABBITMQ_ENDPOINT)
            if "glance_endpoint_placeholder" in line:
                line = line.replace("glance_endpoint_placeholder", GLANCE_ENDPOINT)
            if "region_placeholder" in line:
                line = line.replace("region_placeholder", OS_REGION)
            if "rbd_secret_uuid_palceholder" in line:
                line = line.replace("rbd_secret_uuid_palceholder", RBD_SECRET_UUID)
            if "novncproxy_placeholder" in line:
                line = line.replace("novncproxy_placeholder", NOVNCPROXY_URL)
            if "spiceproxy_placeholder" in line:
                line = line.replace("spiceproxy_placeholder", SPICEPROXY_URL)
            f.write(line + "\n")
            f.truncate()

    with open(tmp.name, 'r') as f:
        info = f.read()
    return info


def main():
    read_kube_config()
    updated_keys = ""
    configmap = get_configmap_definition(CONFIG_MAP_NAME)
    conf = configmap['data'][CONF_FILE_NAME]
    updated_keys = update_connection_fields(conf)

    configmap['data'][CONF_FILE_NAME] = updated_keys
    if not update_configmap(CONFIG_MAP_NAME, configmap):
        sys.exit(1)

if __name__ == "__main__":
    main()
{{- end -}}

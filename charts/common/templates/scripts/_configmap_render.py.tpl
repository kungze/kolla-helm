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
DATABASE_ENDPOINT = os.getenv('DATABASE_ENDPOINT', None)
RABBITMQ_ENDPOINT = os.getenv('RABBITMQ_ENDPOINT', None)
MEMCACHE_ENDPOINT = os.getenv('MEMCACHE_ENDPOINT', None)
CONF_FILE_NAME = os.getenv('CONF_FILE_NAME', None)
CONFIG_MAP_NAME = os.getenv('CONFIG_MAP_NAME', None)
AUTH_URL = os.getenv('AUTH_URL', None)
CINDER_KEYSTONE_PASSWORD = os.getenv('CINDER_KEYSTONE_PASSWORD', None)

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
            if "database_password_placeholder" in line:
                line = line.replace("database_password_placeholder", DB_PASSWORD)
            if "database_endpoint_placeholder" in line:
                line = line.replace("database_endpoint_placeholder", DATABASE_ENDPOINT)
            if "memcache_endpoint_placeholder" in line:
                line = line.replace("memcache_endpoint_placeholder", MEMCACHE_ENDPOINT)
            if "rabbitmq_endpoint_placeholder" in line:
                line = line.replace("rabbitmq_endpoint_placeholder", RABBITMQ_ENDPOINT)
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

import logging
import requests
import os
import sys
import tempfile
import netifaces as ni

KUBE_HOST = None
KUBE_CERT = '/var/run/secrets/kubernetes.io/serviceaccount/ca.crt'
KUBE_TOKEN = None
NAMESPACE =  os.environ['KUBERNETES_NAMESPACE']
TUNNEL_INTERFACE_NAME = os.getenv('TUNNEL_INTERFACE_NAME', None)
CONF_FILE_NAME = os.getenv('CONF_FILE_NAME', None)
CONFIG_MAP_NAME = os.getenv('CONFIG_MAP_NAME', None)
LOG_DATEFMT = "%Y-%m-%d %H:%M:%S"
LOG_FORMAT = "%(asctime)s.%(msecs)03d - %(levelname)s - %(message)s"
logging.basicConfig(format=LOG_FORMAT, datefmt=LOG_DATEFMT)
LOG = logging.getLogger(__name__)
LOG.setLevel(logging.INFO)


def get_tunnel_interface_address(if_name):
    return ni.ifaddresses(if_name)[ni.AF_INET][0]['addr']


def read_kube_config():
    global KUBE_HOST, KUBE_TOKEN
    KUBE_HOST = "https://%s:%s" % ('kubernetes.default',
                                    os.environ['KUBERNETES_SERVICE_PORT'])
    with open('/var/run/secrets/kubernetes.io/serviceaccount/token', 'r') as f:
        KUBE_TOKEN = f.read()


def get_configmap_definition(name):
    url = '%s/api/v1/namespaces/%s/configmaps/%s' % (KUBE_HOST,
                                                        NAMESPACE,
                                                        name)
    resp = requests.get(url,
                        headers={'Authorization': 'Bearer %s' % KUBE_TOKEN},
                        verify=KUBE_CERT)
    if resp.status_code != 200:
        LOG.error('Cannot get configmap %s.', name)
        LOG.error(resp.text)
        return None
    LOG.info('Request configmaps url %s.', url)
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
            if "tunnel_interface_address_placeholder" in line:
                tunnel_interface_address = get_tunnel_interface_address(TUNNEL_INTERFACE_NAME)
                line = line.replace("tunnel_interface_address_placeholder", tunnel_interface_address )
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
    print(conf)
    updated_keys = update_connection_fields(conf)

    configmap['data'][CONF_FILE_NAME] = updated_keys
    if not update_configmap(CONFIG_MAP_NAME, configmap):
        sys.exit(1)

if __name__ == "__main__":
    main()

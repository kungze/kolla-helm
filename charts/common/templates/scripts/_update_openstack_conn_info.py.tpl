{{- define "common.scripts.update_openstack_conn_info" -}}
#!/usr/bin/env python3
import logging
import requests
import os
import sys


KUBE_HOST = None
KUBE_CERT = '/var/run/secrets/kubernetes.io/serviceaccount/ca.crt'
KUBE_TOKEN = None
NAMESPACE = os.getenv('KUBERNETES_NAMESPACE', None)
CONN_INFO_SECRET_NAME = os.getenv('CONN_INFO_SECRET_NAME', None)
SECRET_ADMIN_KEY = os.getenv('SECRET_ADMIN_KEY', None)
SECRET_ADMIN_VALUES = os.getenv('SECRET_ADMIN_VALUES', None)
SECRET_INTERNAL_KEY = os.getenv('SECRET_INTERNAL_KEY', None)
SECRET_INTERNAL_VALUES = os.getenv('SECRET_INTERNAL_VALUES', None)
SECRET_PUBLIC_KEY = os.getenv('SECRET_PUBLIC_KEY', None)
SECRET_PUBLIC_VALUES = os.getenv('SECRET_PUBLIC_VALUES', None)

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


def get_secrets_info(name):
    url = '%s/api/v1/namespaces/%s/secrets/%s' % (KUBE_HOST,
                                                  NAMESPACE,
                                                  name)
    resp = requests.get(url,
                        headers={'Authorization': 'Bearer %s' % KUBE_TOKEN},
                        verify=KUBE_CERT)
    if resp.status_code != 200:
        LOG.error('Cannot get configmap %s.', name)
        LOG.error(resp.text)
        return None
    LOG.info('Request namespaces secrets url %s.', url)
    return resp.json()


def update_secret(secret):
    url = '%s/api/v1/namespaces/%s/secrets/%s' % (KUBE_HOST,
                                                  NAMESPACE,
                                                  CONN_INFO_SECRET_NAME)
    resp = requests.put(url,
                        json=secret,
                        headers={'Authorization': 'Bearer %s' % KUBE_TOKEN},
                        verify=KUBE_CERT)
    if resp.status_code != 200:
        LOG.error(resp.text)
        LOG.error("Update %s Secrets failed!", CONN_INFO_SECRET_NAME)
        return False

    LOG.info("Update %s Secrets success!", CONN_INFO_SECRET_NAME)
    return True


def main():
    read_kube_config()
    self_cm = get_secrets_info(CONN_INFO_SECRET_NAME)
    self_cm['data'][SECRET_ADMIN_KEY] = SECRET_ADMIN_VALUES
    self_cm['data'][SECRET_INTERNAL_KEY] = SECRET_INTERNAL_VALUES
    self_cm['data'][SECRET_PUBLIC_KEY] = SECRET_PUBLIC_VALUES
    if not update_secret(self_cm):
        sys.exit(1)


if __name__ == "__main__":
    main()
{{- end -}}

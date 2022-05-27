{{- define "common.scripts.sync_ceph_cm_secret" -}}
#!/usr/bin/env python3
import logging
import requests
import os
import sys


KUBE_HOST = None
KUBE_CERT = '/var/run/secrets/kubernetes.io/serviceaccount/ca.crt'
KUBE_TOKEN = None
NAMESPACE = os.environ['KUBERNETES_NAMESPACE']
ROOK_CEPH_CLUSTER_NAMESPACE = os.getenv('ROOK_CEPH_CLUSTER_NAMESPACE', None)
ROOK_CEPH_MON_ENDPOINTS_CONFIGMAP = os.getenv('ROOK_CEPH_MON_ENDPOINTS_CONFIGMAP', None)
ROOK_CEPH_CLIENT_SECRET = os.getenv('ROOK_CEPH_CLIENT_SECRET', None)
OS_CEPH_MON_CONFIGMAP = os.getenv('OS_CEPH_MON_CONFIGMAP', None)
OS_CEPH_CLIENT_SECRET = os.getenv('OS_CEPH_CLIENT_SECRET', None)

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


def get_rook_configmap(name):
    url = '%s/api/v1/namespaces/%s/configmaps/%s' % (KUBE_HOST,
                                                     ROOK_CEPH_CLUSTER_NAMESPACE,
                                                     name)
    resp = requests.get(url,
                        headers={'Authorization': 'Bearer %s' % KUBE_TOKEN},
                        verify=KUBE_CERT)
    if resp.status_code != 200:
        LOG.error('Cannot get configmap %s.', name)
        LOG.error(resp.text)
        return None
    LOG.info('Request rook namespaces configmaps url %s.', url)
    return resp.json()


def get_rook_secrets(name):
    url = '%s/api/v1/namespaces/%s/secrets/%s' % (KUBE_HOST,
                                                  ROOK_CEPH_CLUSTER_NAMESPACE,
                                                  name)
    resp = requests.get(url,
                        headers={'Authorization': 'Bearer %s' % KUBE_TOKEN},
                        verify=KUBE_CERT)
    if resp.status_code != 200:
        LOG.error('Cannot get configmap %s.', name)
        LOG.error(resp.text)
        return None
    LOG.info('Request rook namespace secrets url %s.', url)
    return resp.json()


def get_self_configmap(name):
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


def get_self_secret(name):
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
    LOG.info('Request secrets url %s.', url)
    return resp.json()


def update_configmap(configmap):
    url = '%s/api/v1/namespaces/%s/configmaps/%s' % (KUBE_HOST,
                                                     NAMESPACE,
                                                     OS_CEPH_MON_CONFIGMAP)
    resp = requests.put(url,
                        json=configmap,
                        headers={'Authorization': 'Bearer %s' % KUBE_TOKEN},
                        verify=KUBE_CERT)
    if resp.status_code != 200:
        LOG.error(resp.text)
        LOG.error("Update configmap failed!")
        return False
    LOG.info("Update configmap success!")
    return True


def update_secret(secret):
    url = '%s/api/v1/namespaces/%s/secrets/%s' % (KUBE_HOST,
                                                  NAMESPACE,
                                                  OS_CEPH_CLIENT_SECRET)
    resp = requests.put(url,
                        json=secret,
                        headers={'Authorization': 'Bearer %s' % KUBE_TOKEN},
                        verify=KUBE_CERT)
    if resp.status_code != 200:
        LOG.error(resp.text)
        LOG.error("Update Secrets failed!")
        return False

    LOG.info("Update Secrets success!")
    return True


def main():
    read_kube_config()
    rook_cm = get_rook_configmap(ROOK_CEPH_MON_ENDPOINTS_CONFIGMAP)
    rook_secret = get_rook_secrets(ROOK_CEPH_CLIENT_SECRET)

    self_cm = get_self_configmap(OS_CEPH_MON_CONFIGMAP)
    self_secret = get_self_secret(OS_CEPH_CLIENT_SECRET)
    self_cm['data'] = rook_cm['data']
    self_secret['data'] = rook_secret['data']

    if not (update_configmap(self_cm) and update_secret(self_secret)):
        sys.exit(1)


if __name__ == "__main__":
    main()
{{- end -}}

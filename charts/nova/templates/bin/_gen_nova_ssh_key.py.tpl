#!/usr/bin/env python3
import base64
import logging
import requests
import os
import sys

from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.primitives import serialization

KUBE_HOST = None
KUBE_CERT = '/var/run/secrets/kubernetes.io/serviceaccount/ca.crt'
KUBE_TOKEN = None
NAMESPACE = os.environ['KUBERNETES_NAMESPACE']
SSH_SECRET_NAME = os.getenv('SSH_SECRET_NAME', None)

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

def generate_RSA(bits=4096):
    new_key = rsa.generate_private_key(
        public_exponent=65537,
        key_size=bits,
        backend=default_backend()
    )
    private_key = new_key.private_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PrivateFormat.PKCS8,
        encryption_algorithm=serialization.NoEncryption()
    ).decode()
    public_key = new_key.public_key().public_bytes(
        encoding=serialization.Encoding.OpenSSH,
        format=serialization.PublicFormat.OpenSSH
    ).decode()
    return private_key, public_key

def get_self_secret(name):
    url = '%s/api/v1/namespaces/%s/secrets/%s' % (KUBE_HOST,
                                                  NAMESPACE,
                                                  name)
    resp = requests.get(url,
                        headers={'Authorization': 'Bearer %s' % KUBE_TOKEN},
                        verify=KUBE_CERT)
    if resp.status_code != 200:
        LOG.error('Cannot get secrets %s.', name)
        LOG.error(resp.text)
        return None
    LOG.info('Request secrets url %s.', url)
    return resp.json()


def update_secret(secret):
    url = '%s/api/v1/namespaces/%s/secrets/%s' % (KUBE_HOST,
                                                  NAMESPACE,
                                                  SSH_SECRET_NAME)
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

    self_secret = get_self_secret(SSH_SECRET_NAME)
    private_key, public_key = generate_RSA()
    private_key = private_key.encode('utf-8')
    public_key = public_key.encode('utf-8')
    self_secret['data']['private_key'] = base64.b64encode(private_key)
    self_secret['data']['public_key'] = base64.b64encode(public_key)

    if not update_secret(self_secret):
        sys.exit(1)

if __name__ == "__main__":
    main()

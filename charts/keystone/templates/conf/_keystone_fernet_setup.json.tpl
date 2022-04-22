{
    "command": "python3 /tmp/fernet-manage.py fernet_setup",
    "permissions": [
        {
            "path": "/var/log/kolla",
            "owner": "keystone:kolla"
        },
        {
            "path": "/var/log/kolla/keystone/keystone.log",
            "owner": "keystone:keystone"
        }
    ]
}

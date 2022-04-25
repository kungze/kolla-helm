{
    "command": "/usr/bin/keystone-startup.sh",
    "config_files": [
        {
            "source": "/var/lib/kolla/config_files/keystone-startup.sh",
            "dest": "/usr/bin/keystone-startup.sh",
            "owner": "keystone",
            "perm": "0755"
        },
        {
            "source": "/var/lib/kolla/config_files/keystone.conf",
            "dest": "/etc/keystone/keystone.conf",
            "owner": "keystone",
            "perm": "0600"
        },
        {
            "source": "/var/lib/kolla/config_files/wsgi-keystone.conf",
            "dest": "/etc/apache2/conf-enabled/wsgi-keystone.conf",
            "owner": "keystone",
            "perm": "0600"
        }
    ],
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


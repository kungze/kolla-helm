{
    "command": "/tmp/db-sync.sh",
    "config_files": [
        {
            "source": "/var/lib/kolla/config_files/glance-api.conf",
            "dest": "/etc/glance/glance-api.conf",
            "owner": "glance",
            "perm": "0600"
        }
    ],
    "permissions": [
        {
            "path": "/var/log/kolla",
            "owner": "glance:kolla"
        },
        {
            "path": "/var/log/kolla/glance/glance.log",
            "owner": "glance:glance"
        }
    ]
}

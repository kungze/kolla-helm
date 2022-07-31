{
    "command": "nova-scheduler",
    "config_files": [
        {
            "source": "/var/lib/kolla/config_files/nova.conf",
            "dest": "/etc/nova/nova.conf",
            "owner": "nova",
            "perm": "0600"
        }
    ],
    "permissions": [
        {
            "path": "/var/log/kolla/nova",
            "owner": "nova:nova",
            "recurse": true
        }
    ]
}

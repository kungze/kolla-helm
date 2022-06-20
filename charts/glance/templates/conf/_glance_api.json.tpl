{
    "command": "glance-api",
    "config_files": [
        {
            "source": "/var/lib/kolla/config_files/glance-api.conf",
            "dest": "/etc/glance/glance-api.conf",
            "owner": "glance",
            "perm": "0600"
        } ],
    "permissions": [
        {
            "path": "/var/lib/glance",
            "owner": "glance:glance",
            "recurse": true
        },
        {
            "path": "/var/log/kolla/glance",
            "owner": "glance:glance",
            "recurse": true
        }
    ]
}


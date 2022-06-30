{
    "command": "/usr/sbin/apache2 -DFOREGROUND",
    "config_files": [
        {
            "source": "/var/lib/kolla/config_files/placement.conf",
            "dest": "/etc/placement/placement.conf",
            "owner": "placement",
            "perm": "0600"
        },
        {
            "source": "/var/lib/kolla/config_files/placement-api-wsgi.conf",
            "dest": "/etc/apache2/conf-enabled/00-placement-api.conf",
            "owner": "placement",
            "perm": "0600"
        }  ],
    "permissions": [
        {
            "path": "/var/log/kolla/placement",
            "owner": "placement:kolla",
            "recurse": true
        },
        {
            "path": "/var/log/kolla/placement/placement-api.log",
            "owner": "placement:placement"
        }
    ]
}


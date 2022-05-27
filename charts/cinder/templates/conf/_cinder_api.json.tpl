{
    "command": "apache2 -DFOREGROUND",
    "config_files": [
        {
            "source": "/var/lib/kolla/config_files/cinder.conf",
            "dest": "/etc/cinder/cinder.conf",
            "owner": "cinder",
            "perm": "0600"
        },
        {
            "source": "/var/lib/kolla/config_files/cinder-wsgi.conf",
            "dest": "/etc/apache2/conf-enabled/cinder-wsgi.conf",
            "owner": "cinder",
            "perm": "0600"
        }],
    "permissions": [
        {
            "path": "/var/lib/cinder",
            "owner": "cinder:cinder",
            "recurse": true
        },
        {
            "path": "/var/log/kolla/cinder",
            "owner": "cinder:cinder",
            "recurse": true
        }
    ]
}

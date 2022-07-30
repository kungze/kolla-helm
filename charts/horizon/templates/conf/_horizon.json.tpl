{
    "command": "/usr/sbin/apache2 -DFOREGROUND",
    "config_files": [
        {
            "source": "/var/lib/kolla/config_files/horizon.conf",
            "dest": "/etc/apache2/conf-enabled/000-default.conf",
            "owner": "horizon",
            "perm": "0600"
        },
        {
            "source": "/var/lib/kolla/config_files/local_settings",
            "dest": "/etc/openstack-dashboard/local_settings",
            "owner": "horizon",
            "perm": "0600"
        },
        {
            "source": "/var/lib/kolla/config_files/custom_local_settings",
            "dest": "/etc/openstack-dashboard/custom_local_settings",
            "owner": "horizon",
            "perm": "0600"
        }    
    ]
}

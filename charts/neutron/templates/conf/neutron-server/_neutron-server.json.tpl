{
    "command": "neutron-server --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini",
    "config_files": [
        {
            "source": "/var/lib/kolla/config_files/neutron.conf",
            "dest": "/etc/neutron/neutron.conf",
            "owner": "neutron",
            "perm": "0600"
        },
        {
            "source": "/var/lib/kolla/config_files/ml2_conf.ini",
            "dest": "/etc/neutron/plugins/ml2/ml2_conf.ini",
            "owner": "neutron",
            "perm": "0600"
        }
    ],
    "permissions": [
        {
            "path": "/var/log/kolla/neutron",
            "owner": "neutron:neutron",
            "recurse": true
        }
    ]
}

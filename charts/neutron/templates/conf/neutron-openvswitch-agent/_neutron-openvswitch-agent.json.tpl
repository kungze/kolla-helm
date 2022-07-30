{
    "command": "neutron-openvswitch-agent --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/openvswitch_agent.ini",
    "config_files": [
        {
            "source": "/var/lib/kolla/config_files/neutron.conf",
            "dest": "/etc/neutron/neutron.conf",
            "owner": "neutron",
            "perm": "0600"
        },
        {
            "source": "/var/lib/kolla/config_files/openvswitch_agent.ini",
            "dest": "/etc/neutron/plugins/ml2/openvswitch_agent.ini",
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

{
    "command": "/usr/local/bin/neutron-l3-agent-wrapper.sh",
    "config_files": [
        {
            "source": "/var/lib/kolla/config_files/neutron-l3-agent-wrapper.sh",
            "dest": "/usr/local/bin/neutron-l3-agent-wrapper.sh",
            "owner": "root",
            "perm": "0755"
        },
        {
            "source": "/var/lib/kolla/config_files/neutron.conf",
            "dest": "/etc/neutron/neutron.conf",
            "owner": "neutron",
            "perm": "0600"
        },
        {
            "source": "/var/lib/kolla/config_files/neutron_vpnaas.conf",
            "dest": "/etc/neutron/neutron_vpnaas.conf",
            "owner": "neutron",
            "perm": "0600"
        },
        {
            "source": "/var/lib/kolla/config_files/fwaas_driver.ini",
            "dest": "/etc/neutron/fwaas_driver.ini",
            "owner": "neutron",
            "perm": "0600"
        },
        {
            "source": "/var/lib/kolla/config_files/l3_agent.ini",
            "dest": "/etc/neutron/l3_agent.ini",
            "owner": "neutron",
            "perm": "0600"
        }    ],
    "permissions": [
        {
            "path": "/var/log/kolla/neutron",
            "owner": "neutron:neutron",
            "recurse": true
        },
        {
            "path": "/var/lib/neutron/kolla",
            "owner": "neutron:neutron",
            "recurse": true
        }
    ]
}

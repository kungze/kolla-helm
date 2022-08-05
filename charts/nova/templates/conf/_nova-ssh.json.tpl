{
    "command": "/usr/sbin/sshd -D",
    "config_files": [
        {
            "source": "/var/lib/kolla/config_files/sshd_config",
            "dest": "/etc/ssh/sshd_config",
            "owner": "root",
            "perm": "0600"
        },
        {
            "source": "/var/lib/kolla/config_files/ssh_config",
            "dest": "/var/lib/nova/.ssh/config",
            "owner": "nova",
            "perm": "0600"
        },
        {
            "source": "/var/lib/kolla/config_files/id_rsa",
            "dest": "/var/lib/nova/.ssh/id_rsa",
            "owner": "nova",
            "perm": "0600"
        },
        {
            "source": "/var/lib/kolla/config_files/id_rsa.pub",
            "dest": "/var/lib/nova/.ssh/authorized_keys",
            "owner": "nova",
            "perm": "0600"
        }
    ]
}

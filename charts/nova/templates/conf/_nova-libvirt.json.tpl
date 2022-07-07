{
    "command": "/usr/sbin/libvirtd --listen",
    "config_files": [
        {
            "source": "/var/lib/kolla/config_files/libvirtd.conf",
            "dest": "/etc/libvirt/libvirtd.conf",
            "owner": "root",
            "perm": "0600"
        },
        {
            "source": "/var/lib/kolla/config_files/qemu.conf",
            "dest": "/etc/libvirt/qemu.conf",
            "owner": "root",
            "perm": "0600"
        }    ]
}

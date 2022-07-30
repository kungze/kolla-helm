{
    "command": "/tmp/db-sync.sh",
    "config_files": [
        {
            "source": "/var/lib/kolla/config_files/placement.conf",
            "dest": "/etc/placement/placement.conf",
            "owner": "placement",
            "perm": "0600"
        }],
    "permissions": [
        {
            "path": "/var/lib/placement",
            "owner": "placement:placement",
            "recurse": true
        },
        {
            "path": "/var/log/kolla/placement",
            "owner": "placement:placement",
            "recurse": true
        }
    ]
}

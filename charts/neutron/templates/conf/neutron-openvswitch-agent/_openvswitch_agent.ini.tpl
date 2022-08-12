[agent]
tunnel_types = vxlan
l2_population = true

[securitygroup]
firewall_driver = openvswitch

[ovs]
bridge_mappings = physnet1:br-ex
datapath_type = system
ovsdb_connection = tcp:0.0.0.0:6640
local_ip = tunnel_interface_address_placeholder

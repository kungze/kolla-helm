[ml2]
tenant_network_types = {{ .Values.tenant_network_types }}
{{- if .Values.neutron_linuxbridge_agent.enabled }}
type_drivers = flat,vlan
mechanism_drivers = linuxbridge
{{- else if .Values.neutron_openvswitch_agent.enabled }}
type_drivers = flat,vlan,vxlan
mechanism_drivers = openvswitch
{{- end }}
extension_drivers = port_security

[securitygroup]
enable_security_group = true

[ml2_type_vlan]
network_vlan_ranges = physnet1:{{.Values.network_vlan_ranges }}

[ml2_type_flat]
flat_networks = physnet1

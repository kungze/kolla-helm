[fwaas]
enabled = True
agent_version = v2
driver = iptables_v2

[service_providers]
service_provider = FIREWALL_V2:fwaas_db:neutron_fwaas.services.firewall.service_drivers.agents.agents.FirewallAgentDriver:default

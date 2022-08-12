#!/bin/bash

set -o errexit

# NOTE(jeffrey4l): Remove all l3 related netns in case of multiple active routers in l3 high available mode.
neutron-netns-cleanup \
        --config-file /etc/neutron/neutron.conf \
        --config-file /etc/neutron/l3_agent.ini \
        --config-file /etc/neutron/fwaas_driver.ini \
        --force --agent-type l3

neutron-l3-agent \
        --config-file /etc/neutron/neutron.conf \
        --config-file /etc/neutron/neutron_vpnaas.conf \
        --config-file /etc/neutron/l3_agent.ini \
        --config-file /etc/neutron/fwaas_driver.ini

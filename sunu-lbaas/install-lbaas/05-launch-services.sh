#/bin/bash

neutron-lbaasv2-agent --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/lbaas_agent.ini &

service neutron-server restart

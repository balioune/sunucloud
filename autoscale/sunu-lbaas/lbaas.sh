#/bin/bash

## Author: BA Alioune
## Create Load Balancer

neutron lbaas-loadbalancer-create --name test-lb admin_internal_net__subnet

## Create seucurity-group

neutron security-group-create lbaas
neutron security-group-rule-create \
  --direction ingress \
  --protocol tcp \
  --port-range-min 80 \
  --port-range-max 80 \
  --remote-ip-prefix 0.0.0.0/0 \
  lbaas
neutron security-group-rule-create \
  --direction ingress \
  --protocol tcp \
  --port-range-min 443 \
  --port-range-max 443 \
  --remote-ip-prefix 0.0.0.0/0 \
  lbaas
neutron security-group-rule-create \
  --direction ingress \
  --protocol tcp \
  --port-range-min 22 \
  --port-range-max 22 \
  --remote-ip-prefix 0.0.0.0/0 \
  lbaas
neutron security-group-rule-create \
  --direction ingress \
  --protocol icmp \
  lbaas

## create web servers 
tenant_net_id=$(neutron net-list | grep admin_internal_net | awk '{print $2}')
nova boot --image ubuntu --flavor m1.sunucloud --nic net-id=$tenant_net_id,v4-fixed-ip=192.168.111.7 --security-groups lbaas --key-name myKey  server1
nova boot --image ubuntu --flavor m1.sunucloud --nic net-id=$tenant_net_id,v4-fixed-ip=192.168.111.8 --security-groups lbaas --key-name myKey  server2

## Adding an HTTP listener
neutron lbaas-listener-create \
  --name test-lb-http \
  --loadbalancer test-lb \
  --protocol HTTP \
  --protocol-port 80
  
## Get IP of servers
ip_server1=192.168.111.7
ip_server2=192.168.111.8
## Create pools

neutron lbaas-pool-create \
  --name test-lb-pool-http \
  --lb-algorithm ROUND_ROBIN \
  --listener test-lb-http \
  --protocol HTTP
  
neutron lbaas-member-create \
  --subnet admin_internal_net__subnet \
  --address $ip_server1 \
  --protocol-port 80 \
  test-lb-pool-http
  
neutron lbaas-member-create \
  --subnet admin_internal_net__subnet \
  --address $ip_server2 \
  --protocol-port 80 \
  test-lb-pool-http

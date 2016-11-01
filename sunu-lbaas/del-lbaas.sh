#/bin/bash

## Deleting web servers
nova delete server1
nova delete server2

## Delete seucurity-group
neutron security-group-delete lbaas

## Deleting an HTTP listener
neutron lbaas-listener-delete test-lb-http

# Deleting lbaas pool
neutron lbaas-pool-delete test-lb-pool-http

## Deleting the load balancer
neutron lbaas-loadbalancer-delete test-lb

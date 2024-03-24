#!/usr/bin/env bash

echo "⏳ Waiting for the lab to be ready"
sleep 30

echo "Testing broadcast on vni 100"
docker container exec clab-bgp-evpn-host1 ping -c10 -w1 -t1 ff02::1%eth1

echo "Testing broadcast on vni 200"
docker container exec clab-bgp-evpn-host4 ping -c10 -w1 -t1 ff02::1%eth1

echo "Testing broadcast on vni 300"
docker container exec clab-bgp-evpn-host6 ping -c10 -w1 -t1 ff02::1%eth1

echo "Showing vni on h1"
docker container exec clab-bgp-evpn-h1 vtysh -c 'show evpn mac vni 100'
docker container exec clab-bgp-evpn-h1 vtysh -c 'show evpn mac vni 200'
docker container exec clab-bgp-evpn-h1 vtysh -c 'show evpn mac vni 300'

echo "Showing vni on h2"
docker container exec clab-bgp-evpn-h2 vtysh -c 'show evpn mac vni 100'
docker container exec clab-bgp-evpn-h2 vtysh -c 'show evpn mac vni 200'
docker container exec clab-bgp-evpn-h2 vtysh -c 'show evpn mac vni 300'

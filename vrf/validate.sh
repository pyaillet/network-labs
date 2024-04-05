#!/usr/bin/env bash

echo "Test connectivity from interface ens6 / vrf-1"
docker container exec clab-vrf-r1 ping -I ens6 -c 1 192.168.127.254
docker container exec clab-vrf-r1 curl --silent --interface ens6 192.168.127.254

echo "Test connectivity from interface ens7 / vrf-2"
docker container exec clab-vrf-r1 ping -I ens7 -c 1 192.168.127.254
docker container exec clab-vrf-r1 curl --silent --interface ens7 192.168.127.254

echo "Show route tables"
echo "*** vrf-1 ***"
docker container exec clab-vrf-r1 ip route show vrf vrf-1
echo "*** vrf-2 ***"
docker container exec clab-vrf-r1 ip route show vrf vrf-2
echo "*** local ***"
docker container exec clab-vrf-r1 ip route show table local

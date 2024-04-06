#!/usr/bin/env bash

pe1="docker container exec clab-bgp-evpn-l3-pe1"
pe2="docker container exec clab-bgp-evpn-l3-pe2"

echo "Show bgp session on PE1"
$pe1 vtysh -c 'show bgp l2vpn evpn summary'

echo "Show bgp session on PE2"
$pe2 vtysh -c 'show bgp l2vpn evpn summary'

echo "Show bgp evpn routes on PE1"
$pe1 vtysh -c 'show bgp l2vpn evpn'

echo "Show bgp evpn routes on PE2"
$pe2 vtysh -c 'show bgp l2vpn evpn'

echo "Show bgp vrf blue routes on pe1"
$pe1 vtysh -c 'show bgp vrf blue ipv4 unicast'

echo "Show bgp vrf red routes on pe1"
$pe1 vtysh -c 'show bgp vrf red ipv4 unicast'

echo "Show bgp vrf blue routes on pe2"
$pe2 vtysh -c 'show bgp vrf blue ipv4 unicast'

echo "Show bgp vrf red routes on pe2"
$pe2 vtysh -c 'show bgp vrf red ipv4 unicast'

echo "Test ping [red] pe1 -> pe2"
$pe1 ip vrf exec red ping -I 1.0.0.1 -c 3 1.0.0.2

echo "Test ping [blue] pe2 -> pe1"
$pe2 ip vrf exec blue ping -I 2.0.0.2 -c 3 2.0.0.1

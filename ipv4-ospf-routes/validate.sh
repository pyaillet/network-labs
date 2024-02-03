#!/usr/bin/env bash

echo "⏳ Waiting for the lab to be ready"
sleep 60

echo "✅ Testing ping from PC1 to PC3"
docker container exec -it clab-ipv4-ospf-routes-PC1 ping -c1 192.168.13.2

echo "✅ Testing ping from PC1 to PC2"
docker container exec -it clab-ipv4-ospf-routes-PC1 ping -c1 192.168.12.2

echo "✅ Traceroute from PC1 to PC2"
docker container exec -it clab-ipv4-ospf-routes-PC1 traceroute 192.168.12.2

echo "✅ Traceroute from PC1 to PC3"
docker container exec -it clab-ipv4-ospf-routes-PC1 traceroute 192.168.13.2

echo "✂️  Cutting the router1 to router3 link"
docker container exec -it clab-ipv4-ospf-routes-router1 ip link set dev eth2 down

echo "✅ Testing ping from PC1 to PC2"
docker container exec -it clab-ipv4-ospf-routes-PC1 ping -c1 192.168.12.2

echo "✅ Traceroute from PC1 to PC2"
docker container exec -it clab-ipv4-ospf-routes-PC1 traceroute 192.168.12.2

echo "✅ Testing ping from PC1 to PC3"
docker container exec -it clab-ipv4-ospf-routes-PC1 ping -c1 192.168.13.2

echo "✅ Traceroute from PC1 to PC3"
docker container exec -it clab-ipv4-ospf-routes-PC1 traceroute 192.168.13.2

echo "🩹 Fixing the router1 to router3 link"
docker container exec -it clab-ipv4-ospf-routes-router1 ip link set dev eth2 up

echo "⏳ Waiting for the link to come back"
sleep 20

echo "✂️  Cutting the router1 to router2 link"
docker container exec -it clab-ipv4-ospf-routes-router1 ip link set dev eth1 down

echo "❌ Testing ping from PC1 to PC2"
docker container exec -it clab-ipv4-ospf-routes-PC1 ping -c1 -W1 192.168.12.2 || true

echo "❌ Testing ping from PC1 to PC3"
docker container exec -it clab-ipv4-ospf-routes-PC1 ping -c1 -W1 192.168.13.2 || true

echo "🩹 Fixing the router1 to router3 link"
docker container exec -it clab-ipv4-ospf-routes-router1 ip link set dev eth1 up

echo "⏳ Waiting for the link to come back"
sleep 20

echo "✅ Testing ping from PC1 to PC2"
docker container exec -it clab-ipv4-ospf-routes-PC1 ping -c1 192.168.12.2

echo "✅ Traceroute from PC1 to PC2"
docker container exec -it clab-ipv4-ospf-routes-PC1 traceroute 192.168.12.2

echo "✅ Testing ping from PC1 to PC3"
docker container exec -it clab-ipv4-ospf-routes-PC1 ping -c1 192.168.13.2

echo "✅ Traceroute from PC1 to PC3"
docker container exec -it clab-ipv4-ospf-routes-PC1 traceroute 192.168.13.2


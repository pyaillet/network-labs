#!/usr/bin/env bash

echo "✅ Testing ping from pc1 to pc2"
docker container exec -it clab-vxlan-static-vtep-pc1 ping -c1 -W1 192.168.32.20
echo "❌ Testing ping from pc1 to pc3"
docker container exec -it clab-vxlan-static-vtep-pc1 ping -c1 -W1 192.168.32.30 || true
echo "❌ Testing ping from pc1 to pc4"
docker container exec -it clab-vxlan-static-vtep-pc1 ping -c1 -W1 192.168.32.40 || true
echo "✅ Testing ping from pc1 to pc5"
docker container exec -it clab-vxlan-static-vtep-pc1 ping -c1 -W1 192.168.32.50
echo "❌ Testing ping from pc1 to pc6"
docker container exec -it clab-vxlan-static-vtep-pc1 ping -c1 -W1 192.168.32.60 || true
echo "❌ Testing ping from pc3 to pc1"
docker container exec -it clab-vxlan-static-vtep-pc3 ping -c1 -W1 192.168.32.10 || true
echo "❌ Testing ping from pc3 to pc2"
docker container exec -it clab-vxlan-static-vtep-pc3 ping -c1 -W1 192.168.32.20 || true
echo "✅ Testing ping from pc3 to pc4"
docker container exec -it clab-vxlan-static-vtep-pc3 ping -c1 -W1 192.168.32.40
echo "❌ Testing ping from pc3 to pc5"
docker container exec -it clab-vxlan-static-vtep-pc3 ping -c1 -W1 192.168.32.50 || true
echo "✅ Testing ping from pc3 to pc6"
docker container exec -it clab-vxlan-static-vtep-pc3 ping -c1 -W1 192.168.32.60


#!/usr/bin/env bash

echo "⏳ Waiting for the lab to be ready"
sleep 10

echo "✅ Testing ping from pc1-1 to r1"
docker container exec -it clab-ipv6-static-routes-pc1-1 ping6 -c1 -W1 2001:db8:cafe:cafe:10::1
echo "✅ Testing ping from pc1-1 to r2"
docker container exec -it clab-ipv6-static-routes-pc1-1 ping6 -c1 -W1 2001:db8:cafe:cafe:20::1
echo "✅ Testing ping from pc1-1 to r3"
docker container exec -it clab-ipv6-static-routes-pc1-1 ping6 -c1 -W1 2001:db8:cafe:cafe:30::1
echo "✅ Testing ping from pc1-1 to r4"
docker container exec -it clab-ipv6-static-routes-pc1-1 ping6 -c1 -W1 2001:db8:cafe:cafe:40::1
echo "✅ Testing ping from pc1-1 to pc2-1"
docker container exec -it clab-ipv6-static-routes-pc1-1 ping6 -c1 -W1 2001:db8:cafe:cafe:10::3
echo "✅ Testing ping from pc1-1 to pc3-2"
docker container exec -it clab-ipv6-static-routes-pc1-1 ping6 -c1 -W1 2001:db8:cafe:cafe:20::2
echo "✅ Testing ping from pc1-1 to pc4-3"
docker container exec -it clab-ipv6-static-routes-pc1-1 ping6 -c1 -W1 2001:db8:cafe:cafe:30::2
echo "✅ Testing ping from pc1-1 to pc5-4"
docker container exec -it clab-ipv6-static-routes-pc1-1 ping6 -c1 -W1 2001:db8:cafe:cafe:40::2

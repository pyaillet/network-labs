# Docker Network

## Setup

docker container run --name tz-nginx --detach --network none nginx:stable

pid=$(docker inspect -f '{{.State.Pid}}' tz-nginx)
mkdir -p /var/run/netns/
ln -sfT /proc/$pid/ns/net /var/run/netns/tz-nginx

ip netns exec tz-nginx ip addr

ip link add br-tz type bridge

ip addr add 172.42.0.1/16 dev br-tz
ip link set br-tz up

ip link add veth0 type veth peer name ceth0

ip link set ceth0 netns tz-nginx

ip netns exec tz-nginx ip addr add dev ceth0 172.42.0.2/16 
ip netns exec tz-nginx ip link set ceth0 up
ip netns exec tz-nginx ip link set lo up

ip link set veth0 master br-tz
ip link set veth0 up

ping 172.42.0.2

docker container run --name tz-shell --detach --network none zenika/k8s-training-tools:v5 sleep infinity

pid=$(docker inspect -f '{{.State.Pid}}' tz-shell)
mkdir -p /var/run/netns/
ln -sfT /proc/$pid/ns/net /var/run/netns/tz-shell

ip link add veth1 type veth peer name ceth1
ip link set ceth1 netns tz-shell

ip netns exec tz-shell ip addr add dev ceth1 172.42.0.3/16 
ip netns exec tz-shell ip link set ceth1 up
ip netns exec tz-shell ip link set lo up

ip link set veth1 master br-tz
ip link set veth1 up

ping 172.42.0.3

docker exec -it tz-shell ping -c 2 172.42.0.1
docker exec -it tz-shell ping -c 2 172.42.0.2
docker exec -it tz-shell ping -c 2 172.42.0.3

ip netns exec tz-nginx ip neigh
ip netns exec tz-shell ip neigh

ip netns exec tz-nginx ip route add default via 172.42.0.1
ip netns exec tz-shell ip route add default via 172.42.0.1
iptables -t nat -A POSTROUTING -s 172.42.0.0/16 ! -o br-tz -j MASQUERADE
iptables --policy FORWARD ACCEPT

echo 1 > /proc/sys/net/ipv4/ip_forward

docker exec -it tz-shell ping -c 2 8.8.8.8
docker exec -it tz-nginx bash

apt update
apt install -y iputils-ping
ping 8.8.8.8
exit

iptables -t nat -A PREROUTING \
  -d 192.168.0.60 -p tcp -m tcp --dport 80 \
  -j DNAT --to-destination 172.42.0.2:80

iptables -t nat -A OUTPUT \
  -d 192.168.0.60 -p tcp -m tcp --dport 80 \
  -j DNAT --to-destination 172.42.0.2:80

## References

- https://labs.iximiuz.com/tutorials/container-networking-from-scratch
- https://wiki.nftables.org/wiki-nftables/index.php/Moving_from_iptables_to_nftables
- https://www.malekal.com/conntrack-sur-linux-comment-ca-marche/
- https://github.com/pyaillet/network-labs
- https://containerlab.dev/

## Clean up

ip link del veth0
ip link del veth1
ip link del br-tz

docker container rm -f tz-nginx tz-shell

iptables -t nat -D POSTROUTING -s 172.42.0.0/16 ! -o br-tz -j MASQUERADE
iptables -t nat -D PREROUTING \
  -d 192.168.0.60 -p tcp -m tcp --dport 80 \
  -j DNAT --to-destination 172.42.0.2:80

iptables -t nat -D OUTPUT \
  -d 192.168.0.60 -p tcp -m tcp --dport 80 \
  -j DNAT --to-destination 172.42.0.2:80



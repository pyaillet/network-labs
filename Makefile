default:
	@echo "Choose a lab:"
	@echo " - vxlan-multicast"
	@echo " - vxlan-static-vtep"
	@echo " - ipv6-static-routes"
	@echo " - ipv4-ospf-routes"
	@echo " - bgp-evpn"

.PHONY: vxlan-multicast
vxlan-multicast: deploy-vxlan-multicast validate-vxlan-multicast

.PHONY: vxlan-static-vtep
vxlan-static-vtep: deploy-vxlan-static-vtep validate-vxlan-static-vtep

.PHONY: ipv6-static-routes
ipv6-static-routes: deploy-ipv6-static-routes validate-ipv6-static-routes

.PHONY: ipv4-ospf-routes
ipv4-ospf-routes: deploy-ipv4-ospf-routes validate-ipv4-ospf-routes

.PHONY: bgp-evpn
bgp-evpn: prepare-bgp-evpn deploy-bgp-evpn validate-bgp-evpn

deploy-vxlan-multicast:
	sudo containerlab deploy --topo ./vxlan-multicast/topology.yaml

deploy-vxlan-static-vtep:
	sudo containerlab deploy --topo ./vxlan-static-vtep/topology.yaml

deploy-ipv6-static-routes:
	sudo containerlab deploy --topo ./ipv6-static-routes/topology.yaml

deploy-ipv4-ospf-routes:
	sudo containerlab deploy --topo ./ipv4-ospf-routes/topology.yaml

deploy-bgp-evpn:
	sudo containerlab deploy --topo ./bgp-evpn/topology.yaml

prepare-bgp-evpn:
	docker image build ./bgp-evpn/ -t gobgp:local
	sudo ip link add name bgp-evpn-net type bridge
	sudo ip link set bgp-evpn-net up 

validate-vxlan-multicast:
	./vxlan-multicast/validate.sh

validate-vxlan-static-vtep:
	./vxlan-static-vtep/validate.sh

validate-ipv6-static-routes:
	./ipv6-static-routes/validate.sh

validate-ipv4-ospf-routes:
	./ipv4-ospf-routes/validate.sh

validate-bgp-evpn:
	./bgp-evpn/validate.sh

clean:
	sudo containerlab destroy --topo vxlan-multicast/topology.yaml || true
	sudo containerlab destroy --topo vxlan-static-vtep/topology.yaml || true
	sudo containerlab destroy --topo ipv6-static-routes/topology.yaml || true
	sudo containerlab destroy --topo ipv4-ospf-routes/topology.yaml || true
	sudo containerlab destroy --topo bgp-evpn/topology.yaml || true
	sudo ip link del bgp-evpn-net || true

mrproper:
	sudo rm -Rf ./clab-vxlan-multicast
	sudo rm -Rf ./clab-vxlan-static-vtep
	sudo rm -Rf ./clab-ipv6-static-routes
	sudo rm -Rf ./clab-ipv4-ospf-routes
	sudo rm -Rf ./clab-bgp-evpn

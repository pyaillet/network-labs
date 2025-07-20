default:
	@echo "⚗️ Choose a lab:"
	@echo " - vxlan-multicast"
	@echo " - vxlan-static-vtep"
	@echo " - ipv6-static-routes"
	@echo " - ipv4-ospf-routes"
	@echo " - bgp-evpn"
	@echo " - bgp-evpn-l3vpn"
	@echo " - vrf"
	@echo " - ovs-vlan"

include ./.tools/*.mk

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

.PHONY: bgp-evpn-l3vpn
bgp-evpn-l3vpn: deploy-bgp-evpn-l3vpn validate-bgp-evpn-l3vpn

.PHONY: vrf
vrf: prepare-vrf deploy-vrf validate-vrf

.PHONY: ovs-vlan
ovs-vlan: prepare-ovs-vlan deploy-ovs-vlan validate-ovs-vlan

.PHONY: deploy-vxlan-multicast
deploy-vxlan-multicast:
	sudo containerlab deploy --topo ./vxlan-multicast/topology.yaml

.PHONY: deploy-vxlan-static-vtep
deploy-vxlan-static-vtep:
	sudo containerlab deploy --topo ./vxlan-static-vtep/topology.yaml

.PHONY: deploy-ipv6-static-routes
deploy-ipv6-static-routes:
	sudo containerlab deploy --topo ./ipv6-static-routes/topology.yaml

.PHONY: deploy-ipv4-ospf-routes
deploy-ipv4-ospf-routes:
	sudo containerlab deploy --topo ./ipv4-ospf-routes/topology.yaml

.PHONY: deploy-bgp-evpn
deploy-bgp-evpn:
	sudo containerlab deploy --topo ./bgp-evpn/topology.yaml

.PHONY: deploy-bgp-evpn-l3vpn
deploy-bgp-evpn-l3vpn:
	sudo containerlab deploy --topo ./bgp-evpn-l3vpn/topology.yaml

.PHONY: deploy-vrf
deploy-vrf:
	sudo containerlab deploy --topo ./vrf/topology.yaml

.PHONY: deploy-ovs-vlan
deploy-ovs-vlan:
	sudo containerlab deploy --topo ./ovs-vlan/topology.yaml
	
.PHONY: prepare-bgp-evpn
prepare-bgp-evpn:
	docker image build ./bgp-evpn/ -t gobgp:local
	sudo ip link add name bgp-evpn-net type bridge
	sudo ip link set bgp-evpn-net up

.PHONY: prepare-vrf
prepare-vrf:
	docker image build ./vrf/ -t nginx:local

.PHONY: prepare-ovs-vlan
prepare-ovs-vlan:
	sudo ovs-vsctl add-br br0
	sudo ovs-vsctl add-br br1
	sudo ovs-vsctl \
		-- add-port br0 patch0 \
		-- set interface patch0 type=patch options:peer=patch1 \
		-- add-port br1 patch1 \
		-- set interface patch1 type=patch options:peer=patch0
	sudo ovs-vsctl \
		-- add-port br0 ovsp0-1 tag=10 \
		-- add-port br0 ovsp0-2 tag=10 \
		-- add-port br0 ovsp0-3 tag=20 \
		-- add-port br0 ovsp0-4 tag=20 \
		-- add-port br1 ovsp1-1 tag=10 \
		-- add-port br1 ovsp1-2 tag=10 \
		-- add-port br1 ovsp1-3 tag=20 \
		-- add-port br1 ovsp1-4 tag=20

.PHONY: validate-vxlan-multicast
validate-vxlan-multicast:
	./vxlan-multicast/validate.sh

.PHONY: validate-vxlan-static-vtep
validate-vxlan-static-vtep:
	./vxlan-static-vtep/validate.sh

.PHONY: validate-ipv6-static-routes
validate-ipv6-static-routes:
	./ipv6-static-routes/validate.sh

.PHONY: validate-ipv4-ospf-routes
validate-ipv4-ospf-routes:
	./ipv4-ospf-routes/validate.sh

.PHONY: validate-bgp-evpn
validate-bgp-evpn:
	./bgp-evpn/validate.sh

.PHONY: validate-bgp-evpn-l3vpn
validate-bgp-evpn-l3vpn:
	./bgp-evpn-l3vpn/validate.sh

.PHONY: validate-vrf
validate-vrf:
	./vrf/validate.sh

.PHONY: validate-ovs-vlan
validate-ovs-vlan:
	./ovs-vlan/validate.sh

.PHONY: pre-requisites
pre-requisites:
	@echo "🏗️ Installing pre-requisites"
	@sudo bash -c "apt-get -qq update && apt-get -q install -y cloud-image-utils qemu-system qemu-utils"

.PHONY: install-lima
install-lima: $(HOME)/.local/bin/limactl
	@echo "✅ Installed lima-vm"

$(HOME)/.local/bin/limactl:
	@echo "🛠️ Install lima-vm" && \
	export TMP_DIR=$(shell mktemp) && \
	cd $(TMP_DIR) && \
	git clone https://github.com/lima-vm/lima && \
	cd lima && \
	make && \
	make PREFIX=$(HOME)/.local/bin install

.PHONY: clean-ovs-vlan
clean-ovs-vlan:
	sudo containerlab destroy --topo ./ovs-vlan/topology.yaml
	sudo ovs-vsctl \
		-- del-br br0 \
		-- del-br br1

.PHONY: clean
clean:
	sudo containerlab destroy --topo vxlan-multicast/topology.yaml || true
	sudo containerlab destroy --topo vxlan-static-vtep/topology.yaml || true
	sudo containerlab destroy --topo ipv6-static-routes/topology.yaml || true
	sudo containerlab destroy --topo ipv4-ospf-routes/topology.yaml || true
	sudo containerlab destroy --topo bgp-evpn/topology.yaml || true
	sudo containerlab destroy --topo bgp-evpn-l3vpn/topology.yaml || true
	sudo containerlab destroy --topo vrf/topology.yaml || true
	sudo containerlab destroy --topo ovs-vlan/topology.yaml || true

.PHONY: mrproper
mrproper: clean vm-clean
	sudo rm -Rf ./clab-vxlan-multicast
	sudo rm -Rf ./clab-vxlan-static-vtep
	sudo rm -Rf ./clab-ipv6-static-routes
	sudo rm -Rf ./clab-ipv4-ospf-routes
	sudo rm -Rf ./clab-bgp-evpn
	sudo rm -Rf ./clab-bgp-evpn-l3vpn
	sudo rm -Rf ./clab-vrf
	sudo rm -Rf ./clab-ovs-vlan


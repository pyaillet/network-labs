default:
	@echo "Choose a lab:"
	@echo " - vxlan-multicast"
	@echo " - vxlan-static-vtep"
	@echo " - ipv6-static-routes"

.PHONY: vxlan-multicast
vxlan-multicast: deploy-vxlan-multicast validate-vxlan-multicast

.PHONY: vxlan-static-vtep
vxlan-static-vtep: deploy-vxlan-static-vtep validate-vxlan-static-vtep

.PHONY: ipv6-static-routes
ipv6-static-routes: deploy-ipv6-static-routes validate-ipv6-static-routes

deploy-vxlan-multicast:
	sudo containerlab deploy --topo ./vxlan-multicast/topology.yaml

deploy-vxlan-static-vtep:
	sudo containerlab deploy --topo ./vxlan-static-vtep/topology.yaml

deploy-ipv6-static-routes:
	sudo containerlab deploy --topo ./ipv6-static-routes/topology.yaml

validate-vxlan-multicast:
	./vxlan-multicast/validate.sh

validate-vxlan-static-vtep:
	./vxlan-static-vtep/validate.sh

validate-ipv6-static-routes:
	./ipv6-static-routes/validate.sh

clean:
	sudo containerlab destroy --topo vxlan-multicast/topology.yaml || true
	sudo containerlab destroy --topo vxlan-static-vtep/topology.yaml || true
	sudo containerlab destroy --topo ipv6-static-routes/topology.yaml || true

mrproper:
	sudo rm -Rf ./clab-vxlan-multicast
	sudo rm -Rf ./clab-vxlan-static-vtep
	sudo rm -Rf ./clab-ipv6-static-routes

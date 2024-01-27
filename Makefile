default:
	@echo "Choose a lab:"
	@echo " - vxlan-multicast"
	@echo " - vxlan-static-vtep"

.PHONY: vxlan-multicast
vxlan-multicast: deploy-multicast validate-multicast

.PHONY: vxlan-static-vtep
vxlan-static-vtep: deploy-static-vtep validate-static-vtep

deploy-multicast:
	sudo containerlab deploy --topo ./vxlan-multicast/topology.yaml

deploy-static-vtep:
	sudo containerlab deploy --topo ./vxlan-static-vtep/topology.yaml

validate-multicast:
	@echo "Testing ping from pc1 to pc2 ✅"
	docker container exec -it clab-vxlan-multicast-pc1 ping -c1 -W1 192.168.32.20
	@echo "Testing ping from pc1 to pc3 ❌"
	docker container exec -it clab-vxlan-multicast-pc1 ping -c1 -W1 192.168.32.30 || true
	@echo "Testing ping from pc1 to pc4 ❌"
	docker container exec -it clab-vxlan-multicast-pc1 ping -c1 -W1 192.168.32.40 || true
	@echo "Testing ping from pc1 to pc5 ✅"
	docker container exec -it clab-vxlan-multicast-pc1 ping -c1 -W1 192.168.32.50
	@echo "Testing ping from pc1 to pc6 ❌"
	docker container exec -it clab-vxlan-multicast-pc1 ping -c1 -W1 192.168.32.60 || true
	@echo "Testing ping from pc1 to pc7 ✅"
	docker container exec -it clab-vxlan-multicast-pc1 ping -c1 -W1 192.168.32.70
	@echo "Testing ping from pc3 to pc1 ❌"
	docker container exec -it clab-vxlan-multicast-pc3 ping -c1 -W1 192.168.32.10 || true
	@echo "Testing ping from pc3 to pc2 ❌"
	docker container exec -it clab-vxlan-multicast-pc3 ping -c1 -W1 192.168.32.20 || true
	@echo "Testing ping from pc3 to pc4 ✅"
	docker container exec -it clab-vxlan-multicast-pc3 ping -c1 -W1 192.168.32.40
	@echo "Testing ping from pc3 to pc5 ❌"
	docker container exec -it clab-vxlan-multicast-pc3 ping -c1 -W1 192.168.32.50 || true
	@echo "Testing ping from pc3 to pc6 ✅"
	docker container exec -it clab-vxlan-multicast-pc3 ping -c1 -W1 192.168.32.60
	@echo "Testing ping from pc3 to pc7 ❌"
	docker container exec -it clab-vxlan-multicast-pc3 ping -c1 -W1 192.168.32.70 || true

validate-static-vtep:
	@echo "Testing ping from pc1 to pc2 ✅"
	docker container exec -it clab-vxlan-static-vtep-pc1 ping -c1 -W1 192.168.32.20
	@echo "Testing ping from pc1 to pc3 ❌"
	docker container exec -it clab-vxlan-static-vtep-pc1 ping -c1 -W1 192.168.32.30 || true
	@echo "Testing ping from pc1 to pc4 ❌"
	docker container exec -it clab-vxlan-static-vtep-pc1 ping -c1 -W1 192.168.32.40 || true
	@echo "Testing ping from pc1 to pc5 ✅"
	docker container exec -it clab-vxlan-static-vtep-pc1 ping -c1 -W1 192.168.32.50
	@echo "Testing ping from pc1 to pc6 ❌"
	docker container exec -it clab-vxlan-static-vtep-pc1 ping -c1 -W1 192.168.32.60 || true
	@echo "Testing ping from pc3 to pc1 ❌"
	docker container exec -it clab-vxlan-static-vtep-pc3 ping -c1 -W1 192.168.32.10 || true
	@echo "Testing ping from pc3 to pc2 ❌"
	docker container exec -it clab-vxlan-static-vtep-pc3 ping -c1 -W1 192.168.32.20 || true
	@echo "Testing ping from pc3 to pc4 ✅"
	docker container exec -it clab-vxlan-static-vtep-pc3 ping -c1 -W1 192.168.32.40
	@echo "Testing ping from pc3 to pc5 ❌"
	docker container exec -it clab-vxlan-static-vtep-pc3 ping -c1 -W1 192.168.32.50 || true
	@echo "Testing ping from pc3 to pc6 ✅"
	docker container exec -it clab-vxlan-static-vtep-pc3 ping -c1 -W1 192.168.32.60

clean:
	sudo containerlab destroy --topo vxlan-multicast/topology.yaml || true
	sudo containerlab destroy --topo vxlan-static-vtep/topology.yaml || true

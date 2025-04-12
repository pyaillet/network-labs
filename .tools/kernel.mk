
.PHONY: kernel-image
kernel-image:
	docker image build -t linux-build ./.tools/kernel/

.tools/kernel/container.id:
	docker container run -d -v ./.tools/kernel/:/linux/conf -v ./.tools/kernel/dist:/linux/dist --name linux-build linux-build sleep infinity
	docker container ls -f name=linux-build -q > ./.tools/kernel/container.id
 
.PHONY: kernel-conf
kernel-conf: .tools/kernel/container.id
	docker container exec linux-build bash -c "cp /linux/conf/config* /linux/linux/.config"
	docker container exec -it linux-build make menuconfig
	docker cp linux-build:/linux/linux/.config .tools/kernel/config

.PHONY: kernel-build
kernel-build: .tools/kernel/container.id
	docker container exec linux-build make bzImage

.PHONY: kernel-clean
kernel-clean: .tools/kernel/container.id
	docker container rm -f linux-build
	rm .tools/kernel/container.id

.PHONY: kernel-mrproper
kernel-mrproper:
	docker container prune -f
	docker image prune -af
	docker buildx prune -f

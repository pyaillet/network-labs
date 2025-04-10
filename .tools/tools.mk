ARCH := amd64
VERSION := noble

vm:
	@echo "🖥️ Choose an option:"
	@echo " - vm-launch"
	@echo " - vm-stop"
	@echo " - vm-clean"
	@echo " - vm-prepare"
	@echo " - vm-ssh-keys"

vm-clean:
	@echo "🔥 Cleaning files"
	@rm .tools/vm/*

.tools/vm/initrd.img:
	@echo "📦 Downloading initrd.img"
	@curl --silent -LO https://cloud-images.ubuntu.com/$(VERSION)/current/unpacked/$(VERSION)-server-cloudimg-$(ARCH)-initrd-generic
	@mv $(VERSION)-server-cloudimg-$(ARCH)-initrd-generic ./.tools/vm/initrd.img

.tools/vm/vmlinuz:
	@echo "📦 Downloading vmlinuz"
	@curl --silent -LO https://cloud-images.ubuntu.com/$(VERSION)/current/unpacked/$(VERSION)-server-cloudimg-$(ARCH)-vmlinuz-generic
	@mv $(VERSION)-server-cloudimg-$(ARCH)-vmlinuz-generic ./.tools/vm/vmlinuz

.tools/vm/root-disk.img:
	@echo "📦 Downloading disk.img"
	@curl --silent -LO https://cloud-images.ubuntu.com/$(VERSION)/current/$(VERSION)-server-cloudimg-$(ARCH).img
	@mv $(VERSION)-server-cloudimg-$(ARCH).img ./.tools/vm/root-disk.img

.PHONY: download-files
download-files: .tools/vm/initrd.img .tools/vm/vmlinuz .tools/vm/root-disk.img
	@echo "✅ Downloaded files..."

.tools/vm/my-seed.img: .tools/cloudinit/my-meta-data.yaml .tools/cloudinit/user-data.yaml
	@echo "🌱 Creating cloudinit seed"
	@cloud-localds .tools/vm/my-seed.img .tools/cloudinit/user-data.yaml .tools/cloudinit/my-meta-data.yaml

.PHONY: seed
seed: .tools/vm/my-seed.img
	@echo "✅ Created cloudinit seed"

.PHONY: pre-requisites
pre-requisites:
	@echo "🏗️ Installing pre-requisites"
	@sudo bash -c "apt-get -qq update && apt-get -q install -y cloud-image-utils qemu-system"

.PHONY: vm-prepare
vm-prepare: download-files vm-ssh-keys seed
	@echo "✅ VM prepared"

.tools/vm/qemu.pid:
	@echo "🚀 Launching VM"
	@sudo qemu-system-x86_64 \
	  -cpu host \
	  -m 6G \
	  -machine type=q35,accel=kvm -m 2048 \
	  -kernel .tools/vm/vmlinuz \
	  -initrd .tools/vm/initrd.img \
	  -append "root=/dev/vda1 console=ttyS0" \
	  -netdev id=net00,type=user,hostfwd=tcp::20022-:22 \
	  -device virtio-net-pci,netdev=net00 \
	  -snapshot \
	  -drive if=virtio,format=qcow2,file=.tools/vm/root-disk.img \
	  -drive if=virtio,format=raw,file=.tools/vm/my-seed.img \
	  -fsdev local,id=wkspace,path=/workspaces,security_model=mapped,multidevs=remap \
	  -device virtio-9p-pci,fsdev=wkspace,mount_tag=wkspace \
	  -pidfile .tools/vm/qemu.pid \
	  -daemonize \
	  -vnc :0

.PHONY: vm-launch
vm-launch: vm-prepare .tools/vm/qemu.pid

.PHONY: vm-stop
vm-stop: .tools/vm/qemu.pid
	@echo "☠️ Stopping the VM"
	@sudo kill -TERM $(shell sudo cat .tools/vm/qemu.pid)
	@sudo rm -f .tools/vm/qemu.pid

.PHONY: vm-ssh-keys
vm-ssh-keys: .tools/vm/id_ed25519
	@echo "✅ SSH key created"

.tools/vm/id_ed25519:
	@echo "🔑 Create SSH key"
	@ssh-keygen -q -f .tools/vm/id_ed25519 -N ""

.PHONY: vm-ssh
vm-ssh:
	@ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -p 20022 ubuntu@localhost
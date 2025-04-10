ARCH := amd64
DISTRIBUTION := ubuntu
VERSION := noble
GENERIC_VM_PATH := .tools/vm
VM_PATH := $(GENERIC_VM_PATH)/$(DISTRIBUTION)

$(VM_PATH):
	mkdir -p $(VM_PATH)

vm:
	@echo "🖥️ Choose an option:"
	@echo " - vm-launch"
	@echo " - vm-stop"
	@echo " - vm-clean"
	@echo " - vm-prepare"
	@echo " - vm-ssh-keys"

vm-clean:
	@echo "🔥 Cleaning files"
	@rm $(VM_PATH)/*

$(GENERIC_VM_PATH)/ubuntu/initrd.img: $(GENERIC_VM_PATH)/ubuntu
	@echo "📦 Downloading ubuntu initrd.img"
	@curl --silent -LO https://cloud-images.ubuntu.com/$(VERSION)/current/unpacked/$(VERSION)-server-cloudimg-$(ARCH)-initrd-generic
	@mv $(VERSION)-server-cloudimg-$(ARCH)-initrd-generic ./$(VM_PATH)/initrd.img

$(GENERIC_VM_PATH)/ubuntu/vmlinuz: $(GENERIC_VM_PATH)/ubuntu
	@echo "📦 Downloading ubuntu vmlinuz"
	@curl --silent -LO https://cloud-images.ubuntu.com/$(VERSION)/current/unpacked/$(VERSION)-server-cloudimg-$(ARCH)-vmlinuz-generic
	@mv $(VERSION)-server-cloudimg-$(ARCH)-vmlinuz-generic ./$(VM_PATH)/vmlinuz

$(GENERIC_VM_PATH)/ubuntu/root-disk.img: $(GENERIC_VM_PATH)/ubuntu
	@echo "📦 Downloading ubuntu disk.img"
	@curl --silent -LO https://cloud-images.ubuntu.com/$(VERSION)/current/$(VERSION)-server-cloudimg-$(ARCH).img
	@mv $(VERSION)-server-cloudimg-$(ARCH).img ./$(VM_PATH)/root-disk.img
	@qemu-img resize -f qcow2 ./$(VM_PATH)/root-disk.img +10G

$(GENERIC_VM_PATH)/debian/root-disk.img: $(GENERIC_VM_PATH)/debian
	@echo "📦 Downloading debian disk.img"
	@curl -LO https://cloud.debian.org/images/cloud/$(VERSION)/daily/latest/$(DISTRIBUTION)-genericcloud-$(ARCH)-daily.qcow2
	@mv $(DISTRIBUTION)-genericcloud-$(ARCH)-daily.qcow2 ./$(VM_PATH)/root-disk.img
	@qemu-img resize -f qcow2 ./$(VM_PATH)/root-disk.img +10G

$(GENERIC_VM_PATH)/debian/vmlinuz: $(GENERIC_VM_PATH)/debian/root-disk.img
	@sudo modprobe nbd
	@qemu-nbd -c /dev/nbd0 ./$(VM_PATH)/root-disk.img
	@mkdir -p /tmp/debianfs
	@sudo mount /dev/nbd0p1 /tmp/debianfs
	@ls /tmp/debianfs/boot/

.PHONY: download-files
download-files: ./$(VM_PATH)/initrd.img ./$(VM_PATH)/vmlinuz ./$(VM_PATH)/root-disk.img
	@echo "✅ Downloaded files..."

$(VM_PATH)/my-seed.img: .tools/cloudinit/my-meta-data.yaml .tools/cloudinit/user-data.yaml
	@echo "🌱 Creating cloudinit seed"
	@cloud-localds $(VM_PATH)/my-seed.img .tools/cloudinit/user-data.yaml .tools/cloudinit/my-meta-data.yaml

.PHONY: seed
seed: $(VM_PATH)/my-seed.img
	@echo "✅ Created cloudinit seed"

.PHONY: vm-prepare
vm-prepare: download-files vm-ssh-keys seed
	@echo "✅ VM prepared"

$(VM_PATH)/qemu.pid:
	@echo "🚀 Launching VM"
	@sudo qemu-system-x86_64 \
	  -cpu host \
	  -m 6G \
	  -machine type=q35,accel=kvm -m 2048 \
	  -kernel $(VM_PATH)/vmlinuz \
	  -initrd $(VM_PATH)/initrd.img \
	  -append "root=/dev/vda1 console=ttyS0" \
	  -netdev id=net00,type=user,hostfwd=tcp::20022-:22 \
	  -device virtio-net-pci,netdev=net00 \
	  -snapshot \
	  -drive if=virtio,format=qcow2,file=$(VM_PATH)/root-disk.img \
	  -drive if=virtio,format=raw,file=$(VM_PATH)/my-seed.img \
	  -fsdev local,id=wkspace,path=/workspaces,security_model=mapped,multidevs=remap \
	  -device virtio-9p-pci,fsdev=wkspace,mount_tag=wkspace \
	  -pidfile $(VM_PATH)/qemu.pid \
	  -daemonize \
	  -vnc :0

.PHONY: vm-launch
vm-launch: vm-prepare $(VM_PATH)/qemu.pid

.PHONY: vm-stop
vm-stop: $(VM_PATH)/qemu.pid
	@echo "☠️ Stopping the VM"
	@sudo kill -TERM $(shell sudo cat $(VM_PATH)/qemu.pid)
	@sudo rm -f $(VM_PATH)/qemu.pid

.PHONY: vm-ssh-keys
vm-ssh-keys: $(VM_PATH)/id_ed25519
	@echo "✅ SSH key created"

$(VM_PATH)/id_ed25519:
	@echo "🔑 Create SSH key"
	@ssh-keygen -q -f $(VM_PATH)/id_ed25519 -N ""

.PHONY: vm-ssh
vm-ssh:
	@ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -p 20022 -t ubuntu@localhost
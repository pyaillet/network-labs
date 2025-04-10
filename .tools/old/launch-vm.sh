#!/usr/bin/env bash

ARCH=amd64
VERSION=noble

sudo qemu-system-x86_64 \
  -cpu host \
  -m 6G \
  -machine type=q35,accel=kvm -m 2048 \
  -nographic \
  -kernel .tools/vm/vmlinuz \
  -initrd .tools/vm/initrd.img \
  -append "root=/dev/vda1 console=ttyS0" \
  -netdev id=net00,type=user \
  -device virtio-net-pci,netdev=net00 \
  -drive if=virtio,format=qcow2,file=.tools/vm/root-disk.img \
  -drive if=virtio,format=raw,file=.tools/vm/my-seed.img \
  -fsdev local,id=wkspace,path=/workspaces,security_model=mapped,multidevs=remap \
  -device virtio-9p-pci,fsdev=wkspace,mount_tag=wkspace
#!/usr/bin/env bash

ARCH=amd64
VERSION=noble

sudo qemu-system-x86_64 \
  -cpu host \
  -m 6G \
  -machine type=q35,accel=kvm -m 2048 \
  -nographic \
  -kernel ${VERSION}-server-cloudimg-${ARCH}-vmlinuz-generic \
  -initrd ${VERSION}-server-cloudimg-${ARCH}-initrd-generic \
  -append "root=/dev/vda1 console=ttyS0" \
  -netdev id=net00,type=user \
  -device virtio-net-pci,netdev=net00 \
  -drive if=virtio,format=qcow2,file=${VERSION}-server-cloudimg-${ARCH}.img
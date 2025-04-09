#!/usr/bin/env bash

ARCH=amd64
VERSION=noble

curl -LO https://cloud-images.ubuntu.com/${VERSION}/current/${VERSION}-server-cloudimg-${ARCH}.img
curl -LO https://cloud-images.ubuntu.com/${VERSION}/current/unpacked/${VERSION}-server-cloudimg-${ARCH}-initrd-generic
curl -LO https://cloud-images.ubuntu.com/${VERSION}/current/unpacked/${VERSION}-server-cloudimg-${ARCH}-vmlinuz-generic
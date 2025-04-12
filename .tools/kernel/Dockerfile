FROM ubuntu:24.04

RUN apt-get update && \
  apt-get install -y build-essential curl flex bison libncurses-dev bc \
    gawk openssl libssl-dev dkms libelf-dev libudev-dev libpci-dev libiberty-dev autoconf llvm && \
  rm -Rf /var/lib/apt/lists/*

WORKDIR /linux

RUN curl -LO https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.14.2.tar.xz && \
  tar xJf linux-6.14.2.tar.xz && \
  rm -Rf linux-6.14.2.tar.xz && \
  mv linux-* linux

WORKDIR /linux/linux

VOLUME /linux/conf
VOLUME /linux/dist



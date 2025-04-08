FROM ubuntu:24.04

RUN apt-get update && \
  apt-get install -y curl && \
  rm -Rf /var/lib/apt/lists/* && \
  curl -sL https://containerlab.dev/setup | bash -s "all"

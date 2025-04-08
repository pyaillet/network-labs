FROM mcr.microsoft.com/devcontainers/base:bullseye

RUN apt-get update && \
  apt-get install -y curl && \
  rm -Rf /var/lib/apt/lists/* && \
  curl -sL https://containerlab.dev/setup | sudo -E bash -s "all"

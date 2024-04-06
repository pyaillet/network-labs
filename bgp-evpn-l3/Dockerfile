FROM ubuntu:22.04

ENV GOBGP_VERSION=3.24.0

RUN apt-get update && \
  apt-get install -y curl iproute2 && \
  rm -rf /var/lib/apt/lists/* && \
  curl -L https://github.com/osrg/gobgp/releases/download/v${GOBGP_VERSION}/gobgp_${GOBGP_VERSION}_linux_amd64.tar.gz -o /tmp/gobgp.tar.gz && \
  tar xzvf /tmp/gobgp.tar.gz -C /opt && \
  rm /tmp/gobgp.tar.gz

CMD ["/opt/gobgpd", "-f", "/etc/gobgpd/gobgpd.toml"]



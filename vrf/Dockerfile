FROM nginx:stable

RUN apt-get update && \
    apt-get install -y iproute2 net-tools iputils-ping && \
    rm -rf /var/lib/apt/lists/*

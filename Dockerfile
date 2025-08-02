# syntax=docker/dockerfile:1.4
# Description: Dockerfile for a bastion instance to be used inside a k8s cluster
# Author: Frederico Freire Boaventura

FROM ubuntu:24.04

RUN apt update \
    && DEBIAN_FRONTEND=noninteractive apt upgrade -y \
    && DEBIAN_FRONTEND=noninteractive apt install -y \
        bash \
        bind9-dnsutils \
        bind9-host \
        curl \
        ipgrab \
        iproute2 \
        iputils-ping \
        iputils-tracepath \
        mysql-client \
        netcat-openbsd \
        nmap \
        postgresql-client \
        rsync \
        screen \
        sudo \
        tcpdump \
        tcpreplay \
        tcpslice \
        tcptrace \
        tcptraceroute \
        tmux \
        traceroute \
        zsh \
    && rm -rf /var/lib/apt/lists/* \
    && apt clean \
    && apt autoclean \
    && apt autoremove -y \
    && addgroup --gid 1011 --system sysadm \
    && adduser --uid 1011 --system --ingroup sysadm --home /sysadm --shell /bin/bash sysadm \
    && ARCH=$(uname -m) \
    && case ${ARCH} in \
        x86_64) ARCH=amd64 ;; \
        aarch64) ARCH=arm64 ;; \
        armv7l) ARCH=arm ;; \
        s390x) ARCH=s390x ;; \
        ppc64le) ARCH=ppc64le ;; \
        *) echo "Unsupported architecture: $ARCH" && exit 1 ;; \
    esac \
    && KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt) \
    && curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${ARCH}/kubectl" \
    && mv kubectl /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl

COPY files/start.sh /usr/local/bin/start.sh
COPY files/sysadm.sudoers /etc/sudoers.d/sysadm

CMD ["/bin/bash", "/usr/local/bin/start.sh"]

USER sysadm

ARG BUILD_DATE
ARG VCS_REF
ARG VENDOR
ARG VERSION
ARG AUTHOR

LABEL \
      org.opencontainers.image.authors="Frederico Freire Boaventura" \
      org.opencontainers.image.created=$BUILD_DATE \
      org.opencontainers.image.description="Bastion instance to be used inside a k8s cluster" \
      org.opencontainers.image.documentation="https://github.com/fboaventura/dckr-bastion/README.md" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.revision=$VCS_REF \
      org.opencontainers.image.source="https://github.com/fboaventura/dckr-bastion" \
      org.opencontainers.image.title="fboaventura/dckr-mrtg" \
      org.opencontainers.image.url="https://fboaventura.dev" \
      org.opencontainers.image.vendor="Frederico Freire Boaventura" \
      org.opencontainers.image.version="$VERSION"

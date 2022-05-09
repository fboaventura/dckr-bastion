FROM ubuntu:jammy

RUN apt update \
    && DEBIAN_FRONTEND=noninteractive apt install -y apt-utils \
    && DEBIAN_FRONTEND=noninteractive apt upgrade -y \
    && DEBIAN_FRONTEND=noninteractive apt install -y \
        netcat-openbsd iputils-ping traceroute tcptraceroute iputils-tracepath iproute2 \
        mysql-client postgresql-client \
    && rm -rf /var/lib/apt/lists/*

ADD files/start.sh /usr/loca/bin
CMD ["/bin/bash", "/usr/local/bin/start.sh"]

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="Bastion" \
      org.label-schema.description="Bastion instance to be used inside a k8s cluster" \
      org.label-schema.url="https://fboaventura.dev" \
      org.label-schema.vcs-url="https://github.com/fboaventura/dckr-bastion" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vendor="$VENDOR" \
      org.label-schema.version="$VERSION" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.author="$AUTHOR" \
      org.label-schema.docker.dockerfile="/Dockerfile" \
      org.label-schema.license="GPL-2"

FROM debian:stretch
MAINTAINER Thanh NGUYEN <u.nguyenthanh@gmail.com>

# Caddy options
# Download
ENV CADDY_PLUGINS "http.git,http.filebrowser,http.cors,http.realip,http.expires,http.cache"
ENV CADDY_TELEMETRY off

# Configuration
ENV CADDY_ACME_AGREE true
ENV CADDY_ROOT /site
ENV CADDY_CONF ${CADDY_ROOT}/Caddyfile
ENV CADDY_PUBLIC ${CADDY_ROOT}/public

RUN apt-get update && apt-get -y install \
    ca-certificates \
    openssh-client \
    make \
    curl \
    git \
    jq \
    wget \
    && apt-get autoremove

# Download caddyserver
RUN curl -jksSL "https://caddyserver.com/download/linux/amd64?license=personal&telemetry=${CADDY_TELEMETRY}&plugins=${CADDY_PLUGINS}" | tar -xzf - -C /tmp \
    && mv /tmp/caddy /usr/local/bin/caddy \
    && rm -rf /tmp/*

# Create working directory
RUN mkdir -p $CADDY_ROOT
RUN mkdir -p /etc/caddy

# Copy all necessary files
COPY run.sh /

# Define volumes
VOLUME $CADDY_ROOT

WORKDIR /site

CMD ["/run.sh"]

#!/bin/sh

set -x

caddy --conf ${CADDY_CONF} --agree=${CADDY_ACME_AGREE}

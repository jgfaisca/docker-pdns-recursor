#!/bin/bash
#
# Setting up a PowerDNS Recursor for DNSChain
#

# Help function
function show_help() {
   echo
   echo "Invalid number of arguments."
   echo "Usage: ./$(basename "$0") <dnschain_container>"
   echo
}

# Verify arguments
if [ $# -ne 1 ] ; then
    show_help
    exit 1
fi

# Docker image
IMG="zekaf/pdns-recursor"

# Image tag
TAG="latest"

# PowerDNS Recursor container
PDNSR_CT="pdns-recursor"

# PowerDNS Recursor Port
PDNSR_PORT="53"

# Host port
HOST_PORT="53"

# DNSChain container
DNSCHAIN_CT="$1"

# DNSChain configuration
DNSCHAIN_CONF="/etc/dnschain/dnschain.conf"

# DNSChain IP address
DNSCHAIN_IP=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' $DNSCHAIN_CT)

# DNSChain DNS port
DNSCHAIN_PORT=$(docker exec $DNSCHAIN_CT cat $DNSCHAIN_CONF | grep port | awk -F '[/=]' '{print $2}' | sed '2d' | xargs)

# DNSChain IP:port
IP_PORT="${DNSCHAIN_IP}:${DNSCHAIN_PORT}"

docker run -d -p ${HOST_PORT}:${PDNSR_PORT}/udp \
	--net netstatic --ip 172.18.0.53 \
	--name ${PDNSR_CT} $IMG:$TAG \
	--forward-zones=bit.=${IP_PORT},dns.=${IP_PORT},eth.=${IP_PORT},p2p.=${IP_PORT} \
	--export-etc-hosts=no \
	--allow-from=0.0.0.0/0 \
	--local-address=0.0.0.0 \
	--local-port=${PDNSR_PORT}

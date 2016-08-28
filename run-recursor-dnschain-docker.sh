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
TAG="latest"

# Docker network
NET_NAME="isolated_nw"

# PowerDNS Recursor container
PDNSR_CT="pdns-recursor"
PDNSR_PORT="53"
PDNSR_IP="10.17.0.4"

# DNSChain container
DNSCHAIN_CT="$1"
DNSCHAIN_CONF="/etc/dnschain/dnschain.conf"
DNSCHAIN_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $DNSCHAIN_CT)
DNSCHAIN_PORT=$(docker exec $DNSCHAIN_CT cat $DNSCHAIN_CONF | grep port | awk -F '[/=]' '{print $2}' | sed '2d' | xargs)
IP_PORT="${DNSCHAIN_IP}:${DNSCHAIN_PORT}"

# Host port
HOST_PORT="53"

docker run -d -p ${HOST_PORT}:${PDNSR_PORT}/udp \
	--net $NET_NAME --ip $PDNSR_IP \
	--restart=always \
	--name ${PDNSR_CT} $IMG:$TAG \
	--forward-zones=bit.=${IP_PORT},dns.=${IP_PORT},eth.=${IP_PORT},p2p.=${IP_PORT} \
	--export-etc-hosts=no \
	--allow-from=0.0.0.0/0 \
	--local-address=0.0.0.0 \
	--local-port=${PDNSR_PORT}

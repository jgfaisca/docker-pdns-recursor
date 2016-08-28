#!/bin/bash
#
# Create a new bridge network with your subnet and gateway for your ip block
# (add the ability to specify a specific IP for docker containers)
#
# The containers you launch into this network must reside on the
# same Docker host. Each container in the network can immediately
# communicate with other containers in the network. Though, the network
# itself isolates the containers from external networks.
#
# You can expose and publish container ports on containers in this network.
# This is useful if you want to make a portion of the bridge network
# available to an outside network.
#
# example:
# run a nginx container with a specific ip
# docker run --rm -it --net isolated_nw --ip 10.17.0.2 nginx
#

NETNAME="isolated_nw"
SUBNET="10.17.0.0/16"
GATEWAY="10.17.0.1"

# create a new bridge network with your subnet and gateway for your ip block
docker network create --subnet $SUBNET --gateway $GATEWAY $NETNAME


#!/bin/bash

docker run -d -p 53:53/udp --name pdns-recursor zekaf/pdns-recursor:latest

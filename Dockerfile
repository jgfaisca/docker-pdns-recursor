# version 1.0

FROM ubuntu:latest
MAINTAINER Jose G. Faisca <jose.faisca@gmail.com>

ARG DEBIAN_FRONTEND=noninteractive

ENV IMAGE powerdns/pdns-recursor

ENV PORT 53

# -- Install additional packages --
RUN apt-get -y update && apt-get -y install \
curl iproute2 dnsutils 

# -- Install PowerDNS Recursor --
RUN echo "deb http://repo.powerdns.com/ubuntu xenial-rec-40 main" > /etc/apt/sources.list.d/pdns.list 
RUN echo "Package: pdns-*" >> /etc/apt/preferences.d/pdns \
	&& echo "Pin: origin repo.powerdns.com" >> /etc/apt/preferences.d/pdns \
	&& echo "Pin-Priority: 600" >> /etc/apt/preferences.d/pdns
RUN curl https://repo.powerdns.com/FD380FBB-pub.asc | apt-key add - 
RUN apt-get -y update && apt-get -y install pdns-recursor

# -- Change terminal emulator --
RUN echo "" >> ~/.bashrc \
        && echo "# change terminal emulator." >> ~/.bashrc \
        && echo "export TERM=xterm" >> ~/.bashrc

# -- Clean --
RUN cd / \
        && apt-get autoremove -y \
        && apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME ["/etc/powerdns", "/var/zones"]
ADD recursor.conf /etc/powerdns/recursor.conf
ADD zones/example.com /var/zones/example.com

EXPOSE $PORT/udp
ENTRYPOINT ["/usr/sbin/pdns_recursor", "--daemon=no"]

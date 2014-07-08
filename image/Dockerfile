# Use the Makefile from above
# - make build
# - make test
# Credits:
# - olivier.berger@telecom-sudparis.eu
# - https://github.com/phusion/baseimage-docker.git
FROM debian:7.4

MAINTAINER Niklaus Giger <niklaus.giger@member.fsf.org>

ENV HOME /root
RUN mkdir /build
ADD . /build

RUN /build/prepare.sh && \
	/build/system_services.sh && \
	/build/utilities.sh && \
	/build/cleanup.sh

#
# Setup a root password; simple enough to remember, but hard enough that
# it won't be cracked immediately.  (ha!)
#
# RUN echo "root:whatever123" | chpasswd

# ENV LC_ALL C.UTF-8

CMD ["/sbin/my_init"]

# EXPOSE 22
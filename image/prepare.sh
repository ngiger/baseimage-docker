#!/bin/bash
set -e
source /build/buildconfig
set -x

## Temporarily disable dpkg fsync to make building faster.
echo force-unsafe-io > /etc/dpkg/dpkg.cfg.d/02apt-speedup

## Prevent initramfs updates from trying to run grub and lilo.
## https://journal.paul.querna.org/articles/2013/10/15/docker-ubuntu-on-rackspace/
## http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=594189
export INITRD=no
mkdir -p /etc/container_environment
echo -n no > /etc/container_environment/INITRD

echo 'Acquire::http::Proxy "http://172.25.1.70:3142";' > /etc/apt/apt.conf.d/proxy

## Enable Debian sid main
cp /build/sources.list /etc/apt/sources.list
apt-get update

## Fix some issues with APT packages.
## See https://github.com/dotcloud/docker/issues/1024
#dpkg-divert --local --rename --add /sbin/initctl
#ln -sf /bin/true /sbin/initctl
#not needed as done by mkimage-debootstrap.sh for Debian

## Replace the 'ischroot' tool to make it always return true.
## Prevent initscripts updates from breaking /dev/shm.
## https://journal.paul.querna.org/articles/2013/10/15/docker-ubuntu-on-rackspace/
## https://bugs.launchpad.net/launchpad/+bug/974584
dpkg-divert --local --rename --add /usr/bin/ischroot
ln -sf /bin/true /usr/bin/ischroot

## Install HTTPS support for APT.
$minimal_apt_get_install apt-transport-https ca-certificates

## Upgrade all packages.
apt-get dist-upgrade -y --no-install-recommends

## Install add-apt-repository
$minimal_apt_get_install software-properties-common

## TODO: Fix locale.
# $minimal_apt_get_install language-pack-en
# locale-gen en_US

apt-get build-dep --yes ruby ruby-sqlite3
apt-get install --yes imagemagick libmagickwand-dev ruby ruby-dev build-essential libsqlite3-dev git
gem install --no-ri --no-rdoc bundler
gem install --no-ri --no-rdoc puppet           --version=3.5.1
gem install --no-ri --no-rdoc librarian-puppet --version=1.0.3
apt-get clean

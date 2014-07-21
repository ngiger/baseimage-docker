#!/bin/bash
set -e
source /build/buildconfig
set -x

## Often used tools. We need python3 for /sbin/setuser
$minimal_apt_get_install curl less nano vim psmisc python3

## This tool runs a command as another user and sets $HOME.
cp /build/setuser /sbin/setuser

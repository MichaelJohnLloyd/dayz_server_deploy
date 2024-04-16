#!/usr/bin/env bash

apt-get update

DEBIAN_FRONTEND=noninteractive apt-get -y install xfce4

apt install xfce4-session
apt-get -y install xrdp
systemctl enable xrdp
adduser xrdp ssl-cert
echo xfce4-session >~/.xsession
service xrdp restart
passwd michaell 
echo "${RDPUSERPASSWORD}" | passwd <michaell> --stdin
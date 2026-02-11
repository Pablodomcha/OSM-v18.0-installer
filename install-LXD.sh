#!/bin/bash

sudo apt update
sudo apt-get purge lxd lxd-client -y
sudo apt-get install zfsutils-linux -y
sudo snap install lxd

sudo cp LXD-files/60-lxd-production.conf /etc/sysctl.d/60-lxd-production.conf
sudo sysctl --system

lxc network create lxdbr0 ipv6.address=none ipv4.address=10.0.2.15/24 ipv4.nat=true
lxd init

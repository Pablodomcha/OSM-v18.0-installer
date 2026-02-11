#!/bin/bash

sudo apt update
sudo apt-get purge lxd lxd-client -y
sudo apt-get install zfsutils-linux -y
sudo snap install lxd

sudo cp LXD-files/60-lxd-production.conf /etc/sysctl.d/60-lxd-production.conf

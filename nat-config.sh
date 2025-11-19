#!/bin/bash

# Network config in case it's needed
echo "Setting up static IP config for NAT network:"
cat osm-install-files/01-static-config.yaml
sudo cp osm-install-files/99-disable-network-config.cfg /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg
sudo cp osm-install-files/01-static-config.yaml /etc/netplan/01-static-config.yaml
sudo chmod 600 /etc/netplan/01-static-config.yaml
sudo netplan apply

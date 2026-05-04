#!/bin/bash

# Remove network config in case it's needed
echo "Removing up static IP config for NAT network:"
sudo rm /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg
sudo rm /etc/netplan/01-static-config.yaml
sudo netplan apply

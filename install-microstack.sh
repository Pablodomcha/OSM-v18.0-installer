#!/bin/bash

# Installs a snap of microstack
sudo snap install microstack --beta --devmode
sudo microstack init --control --auto

# Get the ubuntu image for the deployments and change permissions for it
sudo wget https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img -O /var/snap/microstack/common/ubuntu20.qcow2
sudo chmod 666 /var/snap/microstack/common/ubuntu20.qcow2

# Uploads the image to microstack
microstack.openstack image create "ubuntu20"   --file /var/snap/microstack/common/ubuntu20.qcow2   --disk-format qcow2   --container-format bare   --public
microstack.openstack image list


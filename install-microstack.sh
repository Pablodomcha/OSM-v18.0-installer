#!/bin/bash

# Installs a snap of microstack and initialize it
sudo snap install microstack --channel=latest/beta
sudo microstack init --control --auto

# Get the ubuntu image for the deployments and change permissions for it
sudo wget https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img -O /var/snap/microstack/common/ubuntu20.qcow2
sudo chmod 666 /var/snap/microstack/common/ubuntu20.qcow2

# Uploads the image to microstack
microstack.openstack image create "ubuntu20"   --file /var/snap/microstack/common/ubuntu20.qcow2   --disk-format qcow2   --container-format bare   --public
microstack.openstack image list

# Get the microstack password
MSPW=$(sudo microstack.openstack configuration show | grep ' password ' | awk '{print $4}')

# Remove the "password" word from the password
MSPWC="${MSPW#password}"

# Export the Microstack password to bashrc
echo "export MSPWC=$MSPWC" >> ~/.bashrc

echo "----------------------------------------------------------------------------------------------"
echo "Stored Microstack password to the MSPWC environment variable in bashrc."
echo "----------------------------------------------------------------------------------------------"
echo "If you didn't run this command with source, you need to run \"source ~/.bashrc\" or close this terminal and open another for the variable to be updated."
echo "----------------------------------------------------------------------------------------------"

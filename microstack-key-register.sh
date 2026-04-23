#!/bin/bash

# Get the microstack password
MSPW=$(sudo microstack.openstack configuration show | grep ' password ' | awk '{print $4}')

# Remove the "password" word from the password
MSPWC="${MSPW#password}"

# Create the microstack VIM with the password
osm vim-create --name microstack-vim --user admin --password $MSPWC --auth_url https://10.0.2.6:5000/v3 --tenant admin --account_type openstack --config '{management_network_name: external, insecure: true}'


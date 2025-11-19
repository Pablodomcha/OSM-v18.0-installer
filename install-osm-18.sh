#!/bin/bash

# Network config in case it's needed
NETWORK=0
OPTIONS="n"

while getopts $OPTIONS opt
do
	case $opt in
		n)
			# Set up the network if the flag was used
			sudo cp osm-install-files/99-disable-network-config.cfg /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg
			sudo cp osm-install-files/01-static-config.yaml /etc/netplan/01-static-config.yaml
		;;
		\?)
			# Handle invalid options
			echo "Error: Invalid option -$OPTARG" >&2
			exit 1
			;;
	esac
done



# Get the OSM files and run the first execution to create the file tree
sudo apt update
sudo apt install net-tools
wget https://osm-download.etsi.org/ftp/osm-18.0-eighteen/install_osm.sh
chmod +x install_osm.sh
./install_osm.sh -y || true

# Change the necessary files for the installation to work
sudo cp osm-install-files/10-install-client-toos.sh /usr/share/osm-devops/installers/10-install-client-tools.sh
sudo cp osm-install-files/values-standalone-ingress-ssh2222.yaml /usr/share/osm-devops/installers/gitea/values-standalone-ingress-ssh2222.yaml
sudo rm -r /usr/share/osm-devops/installers/helm/osm/charts
sudo cp osm-install-files/charts /usr/share/osm-devops/installers/helm/osm/charts

# Run the install again
./install_osm.sh -y 2>&1 | tee osm_install_log.txt

#!/bin/bash

# Run an apt update just in case
sudo apt update

# Install microk8s
# sudo snap install microk8s --classic
# microk8s enable dns storage ingress

# Get the OSM files and run the first execution to create the file tree
sudo apt install net-tools
wget https://osm-download.etsi.org/ftp/osm-19.0-nineteen/install_osm.sh
chmod +x install_osm.sh
./install_osm.sh -y 2>&1 | tee osm_install_log.txt

echo "If this fails, the files needed to be edited to fix in v18.0 were:"
echo "/usr/share/osm-devops/installers/10-install-client-tools.sh"
echo "/usr/share/osm-devops/installers/gitea/values-standalone-ingress-ssh2222.yaml"
echo "/usr/share/osm-devops/installers/helm/osm/charts"
echo "The instructions are in osm-install-files/README.txt"
# Change the necessary files for the installation to work
# sudo cp osm-install-files/10-install-client-tools.sh /usr/share/osm-devops/installers/10-install-client-tools.sh
# sudo cp osm-install-files/values-standalone-ingress-ssh2222.yaml /usr/share/osm-devops/installers/gitea/values-standalone-ingress-ssh2222.yaml
# sudo rm -r /usr/share/osm-devops/installers/helm/osm/charts
# sudo cp -r osm-install-files/charts /usr/share/osm-devops/installers/helm/osm/charts

# Run the install again, saving a log of the installation, in case it's needed for troubleshooting
# ./install_osm.sh -y 2>&1 | tee osm_install_log.txt

# Run export_variables.sh to save the variables
./export_variables.sh

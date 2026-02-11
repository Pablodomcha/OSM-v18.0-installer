#!/bin/bash

# Run an apt update just in case
sudo apt update

# Get the OSM files and run the first execution to create the file tree
touch "$MARKER_FILE"
sudo apt install net-tools
wget https://osm-download.etsi.org/ftp/osm-18.0-eighteen/install_osm.sh
chmod +x install_osm.sh
./install_osm.sh -y --juju --lxd

# Change the necessary files for the installation to work
sudo cp osm-install-files/10-install-client-tools.sh /usr/share/osm-devops/installers/10-install-client-tools.sh
sudo cp osm-install-files/values-standalone-ingress-ssh2222.yaml /usr/share/osm-devops/installers/gitea/values-standalone-ingress-ssh2222.yaml
sudo rm -r /usr/share/osm-devops/installers/helm/osm/charts
sudo cp -r osm-install-files/charts /usr/share/osm-devops/installers/helm/osm/charts

# Run the install again, saving a log of the installation, in case it's needed for troubleshooting
./install_osm.sh --juju --lxd -y 2>&1 | tee osm_install_log.txt

# Save the values of the variables needed and echo them
export OSM_HOSTNAME=$(kubectl get -n osm -o jsonpath="{.spec.rules[0].host}" ingress nbi-ingress)
echo "OSM_HOSTNAME (for osm client): $OSM_HOSTNAME"
export OSM_GUI_URL=$(kubectl get -n osm -o jsonpath="{.spec.rules[0].host}" ingress ngui-ingress)
echo "OSM UI: $OSM_GUI_URL"

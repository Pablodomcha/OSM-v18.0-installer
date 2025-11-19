#!/bin/bash

MARKER_FILE=".osm_setup_complete"

# Returns 0 (true) if the marker file does not exist, indicating a first run.
is_first_execution() {
    if [ ! -f "$MARKER_FILE" ]; then
        return 0
    else
        return 1
    fi
}

# Run an apt update just in case
sudo apt update

# Get the OSM files and run the first execution to create the file tree if it's the first execution of the script
if is_first_execution; then
	touch "$MARKER_FILE"
	sudo apt install net-tools
	wget https://osm-download.etsi.org/ftp/osm-18.0-eighteen/install_osm.sh
	chmod +x install_osm.sh
	./install_osm.sh -y
fi
# If it's not the first execution of the script, this step is ignored, as the file tree is already created

# Change the necessary files for the installation to work
sudo cp osm-install-files/10-install-client-toos.sh /usr/share/osm-devops/installers/10-install-client-tools.sh
sudo cp osm-install-files/values-standalone-ingress-ssh2222.yaml /usr/share/osm-devops/installers/gitea/values-standalone-ingress-ssh2222.yaml
sudo rm -r /usr/share/osm-devops/installers/helm/osm/charts
sudo cp osm-install-files/charts /usr/share/osm-devops/installers/helm/osm/charts

# Run the install again
./install_osm.sh -y 2>&1 | tee osm_install_log.txt

# Save the values of the variables needed and echo them
export OSM_HOSTNAME=$(kubectl get -n osm -o jsonpath="{.spec.rules[0].host}" ingress nbi-ingress)
echo "OSM_HOSTNAME (for osm client): $OSM_HOSTNAME"
export OSM_GUI_URL=$(kubectl get -n osm -o jsonpath="{.spec.rules[0].host}" ingress ngui-ingress)
echo "OSM UI: $OSM_GUI_URL"

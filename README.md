# OSM-v19.0-installer

Installer and functions for Open Source MANO (OSM).

OSM documentation:

https://osm.etsi.org/docs/user-guide/latest/

## License

This project contains modified versions of code from the repositories:

https://github.com/educaredes/sdedge-ns/tree/v1.0.0
https://github.com/educaredes/nfv-lab

Since both of those are under GNU v3.0, so is this work.

Some of the scripts in the repository are intended for use in those labs and are useless otherwise.

## Usage

Some of the scripts in this repo are intended to be executed manually for their function, while others are either executed by another script or copied to a relevant location for them. As such, the ones intended for manual execution will be explained here.

It is recommended to run the scripts from their folder, as they use relative paths when they need to access other files.

### Scripts intended for use in the machine running OSM:

#### install-osm-19.sh

Installs OSM version 19.0 in the machine. The recommended OS by OSM documentation is Ubuntu server 24.04.

#### export_variables.sh

Exports the variables of the hostname and GUI, the hostname variable is needed to run any command in the OSM client. This also updates the IP for the nbi, which doesn't update automatically when the IP for the machine running OSM changes.

#### nat-config.sh

Changes the files to configure the static IP: 10.0.2.15 for it to work in a local Nat network in case DHCP doesn't work. The script itself tells you where to edit the IP in case another is desired.

### Scripts intended for use in a different machine:

#### install-osm-client.sh

Installs the OSM client in the machine, also installing all the requirements. Uses older versions of some of the required programs to allow this to work in Ubuntu 20.04.

The client is needed to run commands in OSM. In fact, the osm installer script from ETSII installs it in the OSM machine by default, though usually you run the commands from another machine.

#### install-microstack.sh

Installs MicroStack in the machine for testing using OpenStack in a laboratory environment. Check MicroStack requirements before attempting to install it.

#### bin-setup-files/microk8s-cert-config

Adds the IP of the machine that is running microk8s to it's trusted list so that it can run microk8s commands in the cluster.

### Scripts specific to the lab:

#### bin-setup-files/rdsv-config-osmlab-NATNetwork

Configures the microk8s dummy VIM and cluster and creates Multus interfaces. Identical to the file in the lab practice but without the tunnel configuration, as it is intended for Nat Network usage.

#### bin-setup-files/rdsv-get-osmlab-2026

Copies the VMs for OSM and K8s in the appropriate folder, changes the VBox VM path to that one and configures the network for the VMs.
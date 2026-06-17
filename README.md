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

Some of the scripts in this repository are intended to be executed manually for their function, while others are either executed by another script or copied to a relevant location for them. As such, the ones intended for manual execution will be explained here.

It is recommended to run the scripts from their folder, as they use relative paths when they need to access other files.

### Scripts intended for use in the machine running OSM:

#### - install-osm-19.sh

Installs OSM version 19.0 in the machine. The recommended OS by OSM documentation is Ubuntu server 24.04.

If this script fails, check "osm-install-files/README.txt" it contains the instructions to fix the problems encountered for OSM v18.0 since they arere likely to appear for OSM v19.0 in the future.

You can always just install OSM v18.0 from it's branch in this repository as it's installer fixes the dependancies itself (as those were already broken when creating it's installer, unlike for v19.0). The scripts in this branch should work for v18.0.

#### - export_variables.sh

Exports the variables of the hostname and GUI, the hostname variable is needed to run any command in the OSM client. This also updates the IP for the nbi, which doesn not update automatically when the IP for the machine running OSM changes.

#### - nat-config.sh

Changes the files to configure the static IP: 10.0.2.15 for it to work in a local Nat network in case DHCP doesn not work. The script itself tells you where to edit the IP in case another is desired.

Can also be used in any other machine for IP configuration purposes, but ensure there are not 2 machines with the same IP.

#### - rm-nat-config.sh

Deletes the files added by "nat-config.sh".

### Scripts intended for use in a different machine:

#### - install-osm-client.sh

Installs the OSM client in the machine, also installing all the requirements. Uses older versions of some of the required programs to allow this to work in Ubuntu 20.04.

The client is needed to run commands in OSM. In fact, the osm installer script from ETSII installs it in the OSM machine by default, though usually you run the commands from another machine.

#### - create-user.sh

Creates many users quickly with simple names and passwords. Intended for educational laboratory environments where you need to create users for all students quickly. Has a -h command to show how it works.

#### - install-microstack.sh

Installs MicroStack in the machine for testing using OpenStack in a laboratory environment. Check MicroStack requirements before attempting to install it.

#### - microk8s-cert-config

Adds the IP of the machine that is running microk8s to it's trusted list so that it can run microk8s commands in the cluster.

If you want to add a different IP, add it to the list of "alt_names" in the file "csr.conf.template" found in "/var/snap/microk8s/current/certs" with a number other than IP.100 (as that one is overwritten by this script), then run this. It will also add the IP of the machine running the command (which has to be the Microk8s machine) appart from the one you added manually.

#### - login.sh

Takes as parameters the OSM NBI, the OSM user, the user's password and the project (in this specific order) and assigns them to the corresponding variables to enable simple OSM login. Has a -h option to display a help message with it's usage.

### Scripts specific to the lab:

#### - bin-setup-files/rdsv-config-osmlab-NATNetwork

Configures the microk8s dummy VIM and cluster and creates Multus interfaces. Identical to the file in the lab practice but without the tunnel configuration, as it is intended for Nat Network usage.

To only configure the VIM and cluster use "rdsv-config-k8s-vim".

To only configure Multus interfaces run "rdsv-config-multus".

#### - bin-setup-files/rdsv-get-osmlab-2026

Copies the VMs for OSM and K8s in the appropriate folder, changes the VBox VM path to that one and configures the network for the VMs.

## Notes

The osm VM sometimes doesn't properly start OSM when restarted. The reason remains unknown and a restart often fixes it.

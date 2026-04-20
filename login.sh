#!/bin/bash

show_help() {
    echo "Usage: $0 OSM_hostname user password project"
    echo ""
    echo "Description: sets the environment variables to use OSM commands as a specific user."
    echo ""
    echo "Options:"
    echo "  -h, --help    Display this help message and exit."
}

# Check if the first argument is a help flag
case "$1" in
    -h|--help)
        show_help
        exit 0
        ;;
esac

# Check if exactly 3 arguments were provided
if [ "$#" -ne 4 ]; then
    echo "Error: Invalid number of arguments."
    show_help
    exit 1
fi

# Assigning the positional parameters to named variables
OSM_HOSTNAME=$1
OSM_USER=$2
OSM_PASSWORD=$3
OSM_PROJECT=$4

echo "export OSM_HOSTNAME=$OSM_HOSTNAME" >> ~/.bashrc
echo "export OSM_USER=$OSM_USER" >> ~/.bashrc
echo "export OSM_PASSWORD=$OSM_PASSWORD" >> ~/.bashrc
echo "export OSM_PROJECT=$OSM_PROJECT" >> ~/.bashrc

echo "--------------------------------------------------------------------------------"
echo "Saving Credentials for OSM..."
echo ""
echo "Now working as user \"$OSM_USER\" in project \"$OSM_PROJECT\" connected to the host \"$OSM_HOSTNAME\""
echo ""
echo "It is reccomended to close this terminal an open a new one to hide your password, you can use \"source ~/.bashrc\" if you do not want to close it."
echo "--------------------------------------------------------------------------------"


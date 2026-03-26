#!/bin/bash

# --- 1. Define the Help Function ---
show_help() {
    echo "If the current password is stored, this command will let you change the admin password."
    echo "If the current password is not stored, this command will store it to be able to use OSm as admin."
    echo "Usage: $0 <new_password>"
    echo ""
    echo "Arguments:"
    echo "  new_password    The password you want to set for the OSM admin user."
    echo ""
    echo "Options:"
    echo "  -h, --help      Show this help message and exit."
}

# --- 2. Check for Help Flags ---
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
    exit 0
fi

# --- 3. Validate Argument Count ---
if [ -z "$1" ]; then
    echo "Error: No password provided."
    show_help
    exit 1
fi

# 2. Try to set the password (in case the current one is already stored)
if [ -n "$OSM_PASSWORD" ]; then
    echo "If used to set the current password, this will return an error, ignore it"
    osm user-update admin --password $1
fi


# Stores the password (in both the case it's being changed or just being set as env variable)
export OSM_PASSWORD=$1
echo $OSM_PASSWORD

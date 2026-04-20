#!/bin/bash

show_help() {
    echo "Usage: $0 user password project"
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
if [ "$#" -ne 3 ]; then
    echo "Error: Invalid number of arguments."
    show_help
    exit 1
fi

# Assigning the positional parameters to named variables
OSM_USER==$1
OSM_PASSWORD=$2
OSM_PROJECT=$3

echo "export OSM_USER=$OSM_USER" >> ~/.bashrc
echo "export OSM_PASSWORD=$OSM_PASSWORD" >> ~/.bashrc
echo "export OSM_PROJECT=$OSM_PROJECT" >> ~/.bashrc

echo "Now working as user $OSM_USER in project $OSM_PROJECT"
echo "Run \"source ~/.bashrc\" now in case you didn't run this with \"source\"."


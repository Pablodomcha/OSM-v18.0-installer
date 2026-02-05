#!/bin/bash
sed -i "s|server: https://.*:6443|server: https://$(ip -4 addr show enp0s3 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'):6443|" ~/.kube/config

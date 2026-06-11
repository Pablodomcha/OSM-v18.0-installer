#!/bin/bash

ETH0_IP=$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
LOCATION="/var/snap/microk8s/current/certs"

# Save current directory and move to LOCATION (silencing the pushd output)
pushd "$LOCATION" > /dev/null

# Check if IP.100 already exists in the file
if grep -q "^IP.100[[:space:]]*=" "csr.conf.template"; then
    # If it exists, update it to the current ETH0_IP
    sudo sed -i "s/^IP.100[[:space:]]*=.*/IP.100 = $ETH0_IP/" "csr.conf.template"
    echo "-- Updated IP.100 to $ETH0_IP in csr.conf.template"
else
    # If it doesn't exist, insert it before #MOREIPS
    sudo sed -i "/#MOREIPS/i IP.100 = $ETH0_IP" "csr.conf.template"
    echo "-- Added IP.100 = $ETH0_IP to csr.conf.template"
fi

# Test if it works with onlt the kubelet one without the extra line
echo "-- Creating private key and signing request"
openssl req -new -nodes -keyout kubelet.key -out kubelet.csr -config csr.conf.template
openssl req -new -nodes -keyout server.key -out server.csr -config csr.conf.template

echo "-- Signing the certificate again with the new IP allowed"

# Sign the certificate again, but this time include the extensions from your template and a proper CA
sudo openssl x509 -req -in kubelet.csr -CA ca.crt -CAkey ca.key -CAcreateserial  -out kubelet.crt -days 365 -extfile csr.conf.template -extensions v3_ext

# Sign the server one too
sudo openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 365 -extfile csr.conf.template -extensions v3_ext

echo "-- Ensuring permissions are correct"
# Ensure permissions are correct
sudo chown root:microk8s kubelet.crt
sudo chmod 660 kubelet.crt

sudo chown root:microk8s server.crt
sudo chmod 660 server.crt

echo "-- Restarting microk8s"
# Restart to apply
sudo microk8s stop
sleep 5
sudo microk8s start

# Return to the original calling folder
popd > /dev/null


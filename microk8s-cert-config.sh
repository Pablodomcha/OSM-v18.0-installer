#!/bin/bash

ETH0_IP=$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
LOCATION="/var/snap/microk8s/current/certs"

cd "$LOCATION"

if ! grep -q "IP.100 = $ETH0_IP" "csr.conf.template"; then
    sudo sed -i "/#MOREIPS/i IP.100 = $ETH0_IP" "csr.conf.template"
    echo "-- Added IP.100 = $ETH0_IP to csr.conf.template"
else
    echo "-- IP already exists in template."
fi

# Test if it works with onlt the kubelet one without the extra line
echo "-- Creating private key and signing request"
openssl req -new -nodes -keyout kubelet.key -out kubelet.csr -config csr.conf.template
openssl req -new -nodes -keyout server.key -out server.csr -config csr.conf.template

echo "-- Signing the certificate again with the new IP allowed"
# Sign the certificate with a self-signed certificate first (no idea why this is needed)
sudo openssl x509 -req -in kubelet.csr -signkey kubelet.key -out kubelet.crt -days 365 -extfile csr.conf.template -extensions v3_ext

# Sign the certificate again, but this time include the extensions from your template and a proper CA
sudo openssl x509 -req -in kubelet.csr -CA ca.crt -CAkey ca.key -CAcreateserial  -out kubelet.crt -days 365 -extfile csr.conf.template -extensions v3_ext

# Sign this one too (no idea why, but without it fails)
sudo openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 365 -extfile csr.conf.template -extensions v3_ext

echo "-- Ensuring permissions are correct"
# Ensure permissions are correct
sudo chown root:microk8s kubelet.crt
sudo chmod 660 kubelet.crt

sudo chown root:microk8s server.crt
sudo chmod 660 server.crt

echo "-- Restarting microk8s"
# Restart to apply
sudo microk8s stop && sudo microk8s start


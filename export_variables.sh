#!/bin/bash

# 1. Get the actual current IP of the interface
CURRENT_IP=$(ip -4 addr show enp0s3 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

# 2. Update the local kubeconfig first
sed -i "s|server: https://.*:6443|server: https://${CURRENT_IP}:6443|" ~/.kube/config

# 3. Force update the Ingresses in K8s to use the NEW IP
kubectl patch ingress nbi-ingress -n osm --type='json' -p="[{\"op\": \"replace\", \"path\": \"/spec/rules/0/host\", \"value\":\"nbi.${CURRENT_IP}.nip.io\"}]" > /dev/null
kubectl patch ingress ngui-ingress -n osm --type='json' -p="[{\"op\": \"replace\", \"path\": \"/spec/rules/0/host\", \"value\":\"gui.${CURRENT_IP}.nip.io\"}]" > /dev/null

# 4. Now capture the variables as you did before
export OSM_HOSTNAME=$(kubectl get -n osm -o jsonpath="{.spec.rules[0].host}" ingress nbi-ingress)
echo "OSM_HOSTNAME (for osm client): $OSM_HOSTNAME"

export OSM_GUI_URL=$(kubectl get -n osm -o jsonpath="{.spec.rules[0].host}" ingress ngui-ingress)
echo "OSM UI: $OSM_GUI_URL"

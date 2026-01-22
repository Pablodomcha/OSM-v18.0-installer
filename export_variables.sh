#!/bin/bash

# Save the values of the variables needed and echo them
export OSM_HOSTNAME=$(kubectl get -n osm -o jsonpath="{.spec.rules[0].host}" ingress nbi-ingress)
echo "OSM_HOSTNAME (for osm client): $OSM_HOSTNAME"
export OSM_GUI_URL=$(kubectl get -n osm -o jsonpath="{.spec.rules[0].host}" ingress ngui-ingress)
echo "OSM UI: $OSM_GUI_URL"

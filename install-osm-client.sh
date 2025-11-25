OSM_CLIENT_VERSION="v18.0"
echo $OSM_CLIENT_VERSION
OSM_IM_VERSION="v18.0"
echo $OSM_IM_VERSION
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y python3 python3-setuptools python3-dev python3-pip
echo $DEBIAN_FRONTEND
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y libmagic1
echo $DEBIAN_FRONTEND
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y make
echo $DEBIAN_FRONTEND
echo "Running the pip install"
sudo -H python3 -m pip install -U pip
# Install OSM IM and its dependencies via pip
echo "-----------------------------------------------"
echo "Installing OSM IM and its dependencies via pip"
echo "-----------------------------------------------"
echo "Installing https://osm.etsi.org/gitweb/?p=osm/IM.git;a=blob_plain;f=requirements.txt;hb=${OSM_IM_VERSION}"
python3 -m pip install -r "https://osm.etsi.org/gitweb/?p=osm/IM.git;a=blob_plain;f=requirements.txt;hb=${OSM_IM_VERSION}"
# Path needs to include $HOME/.local/bin in order to use pyang
[ "$(which pyang)" = "$HOME/.local/bin/pyang" ] || export PATH=$HOME/.local/bin:${PATH}
echo "Installing git+https://osm.etsi.org/gerrit/osm/IM.git@${OSM_IM_VERSION}#egg=osm-im (step 1/3)"
python3 -m pip install "git+https://osm.etsi.org/gerrit/osm/IM.git@${OSM_IM_VERSION}#egg=osm-im" --upgrade --no-build-isolation
echo "Installing https://osm.etsi.org/gitweb/?p=osm/osmclient.git;a=blob_plain;f=requirements.txt;hb=${OSM_CLIENT_VERSION} (step 2/3)"
python3 -m pip install -r "https://osm.etsi.org/gitweb/?p=osm/osmclient.git;a=blob_plain;f=requirements.txt;hb=${OSM_CLIENT_VERSION}"
echo "Installing git+https://osm.etsi.org/gerrit/osm/osmclient.git@${OSM_CLIENT_VERSION}#egg=osmclient (step 3/3)"
python3 -m pip install git+https://osm.etsi.org/gerrit/osm/osmclient.git@${OSM_CLIENT_VERSION}#egg=osmclient

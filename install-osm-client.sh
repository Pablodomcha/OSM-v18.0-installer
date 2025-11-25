OSM_CLIENT_VERSION="v18.0"
OSM_IM_VERSION="v18.0"
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y python3 python3-setuptools python3-dev python3-pip
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y libmagic1
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y make
sudo -H python3 -m pip install -U pip
# Install OSM IM and its dependencies via pip
python3 -m pip install -r "https://osm.etsi.org/gitweb/?p=osm/IM.git;a=blob_plain;f=requirements.txt;hb=${OSM_IM_VERSION}"
# Path needs to include $HOME/.local/bin in order to use pyang
[ "$(which pyang)" = "$HOME/.local/bin/pyang" ] || export PATH=$HOME/.local/bin:${PATH}
python3 -m pip install "git+https://osm.etsi.org/gerrit/osm/IM.git@${OSM_IM_VERSION}#egg=osm-im" --upgrade
python3 -m pip install -r "https://osm.etsi.org/gitweb/?p=osm/osmclient.git;a=blob_plain;f=requirements.txt;hb=${OSM_CLIENT_VERSION}"
python3 -m pip install git+https://osm.etsi.org/gerrit/osm/osmclient.git@${OSM_CLIENT_VERSION}#egg=osmclient

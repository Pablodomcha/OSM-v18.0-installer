To fix the problems that most likely come from dependancies becoming legacy, follow these steps:

1.	Add:
		"--no-build-isolation"
	to the line:
		"python3 -m pip install "git+https://osm.etsi.org/gerrit/osm/IM.git@${OSM_IM_VERSION}#egg=osm-im" --upgrade"
	in:
		/usr/share/osm-devops/installers/10-install-client-tools.sh

2. 	Change the repository in:
		/usr/share/osm-devops/installers/gitea/values-standalone-ingress-ssh2222.yaml
	from:
		repository: bitnami/...
	to:
		repository: bitnamilegacy/...
	for any repositories that have become legacy

3.	Unpack the files in:
		/usr/share/osm-devops/installers/helm/osm/charts
	with:
		sudo tar -xzf mongodb-13.9.4.tgz
	then remove the tgz files to ensure it's loading from the folders and not the tar files you don't need to compress the results, this will load from the folders without issue.

4.	Do the same replacement as step 2. To find which files may need to be renamed just do:
		grep -r "bitnami/" .

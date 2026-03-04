To fix the problems that most likely come from dependancies becoming legacy or pip installation, follow these steps:

-------------------------
|			|
|	PIP ERROR	|
|			|
-------------------------

1.	If there is a problem with pip, add:
		"--no-build-isolation"
	to the line:
		"python3 -m pip install "git+https://osm.etsi.org/gerrit/osm/IM.git@${OSM_IM_VERSION}#egg=osm-im" --upgrade"
	in:
		/usr/share/osm-devops/installers/10-install-client-tools.sh
	The line ensd up as: 
		"python3 -m pip install "git+https://osm.etsi.org/gerrit/osm/IM.git@${OSM_IM_VERSION}#egg=osm-im" --upgrade --no-build-isolation"
		
---------------------------------
|				|
|	DEPENDANCY ERROR	|
|				|
---------------------------------

1. 	Change the repository in:
		/usr/share/osm-devops/installers/gitea/values-standalone-ingress-ssh2222.yaml
	from:
		repository: bitnami/...
	to:
		repository: bitnamilegacy/...
	for any repositories that have become legacy

2.	Unpack the files in:
		/usr/share/osm-devops/installers/helm/osm/charts
	with:
		sudo tar -xzf <filename>
	then remove the tgz files to ensure it's loading from the folders and not the tar files you don't need to compress the results, this will load from the folders without issue.
	Do the same replacement as step 2. To find which files may need to be edited:
		grep -r "bitnami/" .

---------------------------------
|				|
|	IMPORTANT NOTE		|
|				|
---------------------------------

It's important to check which dependancies have become legacy by checking their repositories for the version used in OSM, if a dpenedancy that hasn't become legacy is renamed as such, OSM will fail to install as it won't find it just like it can't find the ones that are legacy but not marked as such.

#!/bin/bash

# 1. Check if the public key exists; if not, generate it
if [ ! -f ~/.ssh/id_rsa.pub ]; then
    echo "SSH key not found. Generating one..."
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
fi

PUB_KEY=$(cat ~/.ssh/id_rsa.pub)
echo "Public Key: $PUB_KEY"

# 2. Iterate through each VNF directory
for dir in *_vnfd/; do
    # Remove trailing slash for naming
    dirname=${dir%/}
    
    # Define the path to the cloud_init file based on your structure
    # e.g., bcg1_vnfd/cloud_init/bcg1_cloud_init.cfg
    vnf_name=${dirname%_vnfd}
    cfg_file="${dir}cloud_init/${vnf_name}_cloud_init.cfg"

    if [ -f "$cfg_file" ]; then
        echo "Processing $vnf_name..."

        # Check if users section already exists to avoid double injection
        if ! grep -q "ssh_authorized_keys" "$cfg_file"; then
            # Inject the users and ssh_authorized_keys block after #cloud-config
            sed -i "/#cloud-config/a users:\n  - name: ubuntu\n    sudo: ALL=(ALL) NOPASSWD:ALL\n    shell: /bin/bash\n    ssh_authorized_keys:\n      - $PUB_KEY" "$cfg_file"
            echo "  [+] SSH key injected into $cfg_file"
        else
            echo "  [!] SSH key already present in $cfg_file. Skipping injection."
        fi

        # 3. Re-package the directory into a .tar.gz
        tar -czf "${dirname}.tar.gz" "$dirname"
        echo "  [+] Re-packaged ${dirname}.tar.gz"
    else
        echo "  [?] Skipping $dir: $cfg_file not found."
    fi
done

echo "Done! Your packages are updated and ready for upload."

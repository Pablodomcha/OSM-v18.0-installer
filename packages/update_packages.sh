#!/bin/bash

# 1. Check if the public key exists; if not, generate it
if [ ! -f ~/.ssh/id_rsa.pub ]; then
    echo "SSH key not found. Generating one..."
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
fi

PUB_KEY=$(cat ~/.ssh/id_rsa.pub)

# 2. Iterate through each VNF directory
for dir in *_vnfd/; do
    dirname=${dir%/}
    # The VNF descriptor is now the primary target for unified files
    vnfd_file="${dir}${dirname}.yaml"

    if [ -f "$vnfd_file" ]; then
        echo "Processing unified VNFD: $dirname..."

        # Check if SSH key already exists to avoid double injection
        if ! grep -q "ssh_authorized_keys" "$vnfd_file"; then
            
            # Injection logic for INLINE cloud-init (used in your new unified files)
            # We look for '#cloud-config' inside the YAML and indent the user block
            # Note: YAML requires 8 spaces of indentation inside the cloud-init: | block
            sed -i "/#cloud-config/a \        users:\n          - name: ubuntu\n            sudo: ALL=(ALL) NOPASSWD:ALL\n            shell: /bin/bash\n            ssh_authorized_keys:\n              - $PUB_KEY" "$vnfd_file"
            
            echo "  [+] SSH key injected into inline cloud-init in $vnfd_file"
        else
            echo "  [!] SSH key already present in $vnfd_file. Skipping."
        fi

        # 3. Re-package the directory
        tar -czf "${dirname}.tar.gz" "$dirname"
        echo "  [+] Re-packaged ${dirname}.tar.gz"
    else
        echo "  [?] Skipping $dir: $vnfd_file not found."
    fi
done

echo "Done! Your unified packages are updated with SSH keys."

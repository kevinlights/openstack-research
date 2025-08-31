sudo apt install -y qemu-kvm cloud-image-utils libvirt-daemon-system libvirt-clients
sudo systemctl enable --now libvirtd
sudo systemctl start libvirtd
sudo systemctl status libvirtd
sudo usermod -aG kvm $USER
sudo usermod -aG libvirt $USER
virsh list --all




# https://www.surlyjake.com/blog/2020/10/09/ubuntu-cloud-images-in-libvirt-and-virt-manager/
# https://blog.csdn.net/fengidea/article/details/144212876
# https://docs.cloud-init.io/en/latest/reference/yaml_examples/apt.html
# https://docs.cloud-init.io/en/latest/reference/examples.html

cat <<'EOF' > meta-data
#cloud-config
instance-id: my-vm1
local-hostname: my-vm1
EOF

cat <<'EOF' > network-config
#cloud-config
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: true
EOF



# cat <<'EOF' > user-data
# users:
#   - name: app
#     passwd: 
#     sudo: ['ALL=(ALL) NOPASSWD:ALL']
#     groups: sudo

# # runs apt-get update
# package_update: true

# # runs apt-get upgrade
# package_upgrade: true

# # installing additional packages
# packages:
#   - docker
#   - docker-compose

# # run some commands on first boot
# runcmd:
#   - systemctl daemon-reload
#   - systemctl enable docker
#   - systemctl start --no-block docker

# # after system comes up first time. 
# final_message: "The system is finally up, after $UPTIME seconds"
# EOF

# virt-install \
#   --name vm1 \
#   --memory 1024 \
#   --vcpus 1 \
#   --os-type linux \
#   --os-variant ubuntu22.04 \
#   --network bridge=virbr0 \
#   --nographics --disk size=10,backing_store=$PWD"/focal-server-cloudimg-amd64.img",bus=virtio \
#   --cloud-init user-data=$PWD"/user-data",meta-data=${PWD}"/meta-data"

# apt install whois
# mkpasswd --method=SHA-512 --rounds=4096

cat <<'EOF' > user-data
#cloud-config
hostname: my-vm2
ntp:
  enabled: true
  ntp_client: chrony
manage_resolv_conf: true
resolv_conf:
  nameservers: [8.8.8.8, 8.8.4.4]
users:
  - name: ubuntu
    passwd: $6$rounds=4096$C6aNdJAOP4X/gA3i$PNTPBzcWIeKht9epMa2OzdO4pHgVhaxoplgsgs3lOjwb9ff.HGTZlvQceCqGqy43VdxIfirPhPjJwe5Bc6K2d0
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    groups: sudo
    shell: /bin/bash
    lock_passwd: false
ssh_pwauth: true
chpasswd:
  list: |
    root:root
  expire: False
apt:
  primary:
    - arches: [default]
      search:
        - http://mirrors.aliyun.com/ubuntu/
package_update: true
packages:
  - inetutils-ping
  - net-tools
  - bridge-utils
  - vlan
  - uml-utilities
  - inetutils-traceroute
# after system comes up first time. 
final_message: "The system is finally up, after $UPTIME seconds"
EOF

cp ubuntu-22.04-minimal-cloudimg-amd64.img /var/lib/libvirt/images/ubuntu2204.img
virt-install \
  --name vm2 \
  --memory 1024 \
  --vcpus 1 \
  --os-variant ubuntu22.04 \
  --nographics --disk size=10,backing_store="/var/lib/libvirt/images/ubuntu2204.img",bus=virtio \
  --cloud-init user-data=$PWD"/user-data"


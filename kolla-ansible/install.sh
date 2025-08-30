# https://docs.openstack.org/kolla-ansible/latest/user/quickstart.html
# https://www.cnblogs.com/fsdstudy/p/18300625

# Ubuntu 2204 cloud image
# Nested VT-x/AMD-V
# 10GB Memory 4 GPU 100G Disk 
# two ethes
# enp0s3 bridge wifi
# enp0s8 natnetwork



sudo apt install git python3-dev libffi-dev gcc libssl-dev libdbus-glib-1-dev
sudo apt install python3-venv

cd ~
python3 -m venv kolla-venv
source ~/kolla-venv/bin/activate
mkdir -p kolla
cd kolla

pip install -U pip
pip3 install 'ansible-core>=2.15,<2.16.99' kolla-ansible

sudo mkdir -p /etc/kolla
sudo chown $USER:$USER /etc/kolla

cp -r ~/kolla-venv/share/kolla-ansible/etc_examples/kolla/* /etc/kolla
cp ~/kolla-venv/share/kolla-ansible/ansible/inventory/all-in-one .


kolla-ansible install-deps
kolla-genpwd

vim /etc/kolla/globals.yml

vim /etc/hosts
# 192.168.xxx.xxx int.ocp-dev.com ext.ocp-dev.com



kolla-ansible bootstrap-servers -i ./all-in-one -vvv 2>&1 | tee -a bootstrap-servers.log
kolla-ansible prechecks -i ./all-in-one -vvv 2>&1 | tee -a prechecks.log
kolla-ansible deploy -i ./all-in-one -vvv 2>&1 | tee -a deploy.log
kolla-ansible post-deploy -vvv 2>&1 | tee -a post-deploy.log

# if network timeout during start containers, check route and default gateway
# ping -c 4 8.8.8.8
# ip route
# sudo ip route delete default
# ip route
# ping -c 4 8.8.8.8

pip install python-openstackclient -c https://releases.openstack.org/constraints/upper/master

source /etc/kolla/admin-openrc.sh

openstack catalog list

# how to reconfigure openstack with globals
kolla-ansible reconfigure -i all-in-one -vvv 2>&1 | tee -a reconfigure.log


# how to update network config
su root
vim /etc/kolla/neutron-server/ml2_conf.ini
# [ml2]
# type_drivers = flat,vlan,vxlan,local,gre
# tenant_network_types = vxlan
# mechanism_drivers = openvswitch,l2population
# extension_drivers = port_security

# [ml2_type_vlan]
# network_vlan_ranges = physnet1:10:1000

# [ml2_type_flat]
# flat_networks = physnet1

# [ml2_type_vxlan]
# vni_ranges = 1:1000


# type_drivers: add local and gre drivers
# network_vlan_ranges: add vlan support and range
docker restart neutron-server



# how to enable multi domains
vim /etc/kolla/horizon/_9998-kolla-settings.py
# OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT = True
docker restart horizon




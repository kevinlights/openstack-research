sudo apt install openssh-server
sudo server ssh start
sudo systemctl enable ssh


sudo mv /etc/apt/sources.list /etc/apt/sources.list.bak

cat | sudo tee /etc/apt/sources.list <<EOF
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial main restricted universe multiverse
# deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-updates main restricted universe multiverse
# deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-updates main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-backports main restricted universe multiverse
# deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-backports main restricted universe multiverse

# 以下安全更新软件源包含了官方源与镜像站配置，如有需要可自行修改注释切换
deb http://security.ubuntu.com/ubuntu/ xenial-security main restricted universe multiverse
# deb-src http://security.ubuntu.com/ubuntu/ xenial-security main restricted universe multiverse

# 预发布软件源，不建议启用
# deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-proposed main restricted universe multiverse
# # deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-proposed main restricted universe multiverse
EOF


# https://www.voidking.com/dev-virtualbox-ubuntu-openstack/

# wget https://github.com/conda-forge/miniforge/releases/download/25.3.0-3/Miniforge3-25.3.0-3-Linux-x86_64.sh

sudo apt install git python3 python3-pip python3-os-testr bridge-utils

# sudo ln -s /opt/stack/miniforge3/bin/python /usr/bin/python
# sudo ln -s /opt/stack/miniforge3/bin/pip /usr/bin/pip
sudo ln -s /usr/bin/python3 /usr/bin/python
sudo ln -s /usr/bin/pip3 /usr/bin/pip

sudo useradd -s /bin/bash -d /opt/stack -m stack
echo "stack ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/stack
sudo passwd stack
su - stack

mkdir -p ~/.pip
cat <<EOF | tee ~/.pip/pip.conf
[global]
index-url = https://pypi.doubanio.com/simple
EOF

sudo mkdir -p /root/.pip
sudo cp ~/.pip/pip.conf /root/.pip

rm -rf requirements/ keystone/ nova/ glance/ cinder/ neutron/ swift/ horizon/ devstack/
git clone https://opendev.org/openstack/devstack --branch rocky-eol --depth=1
git clone https://git.openstack.org/openstack/requirements.git /opt/stack/requirements --branch rocky-eol --depth=1
git clone https://git.openstack.org/openstack/keystone.git /opt/stack/keystone --branch rocky-eol --depth=1
git clone https://git.openstack.org/openstack/nova.git /opt/stack/nova --branch rocky-eol --depth=1
git clone https://git.openstack.org/openstack/glance.git /opt/stack/glance --branch rocky-eol --depth=1
git clone https://git.openstack.org/openstack/cinder.git /opt/stack/cinder --branch rocky-eol --depth=1
git clone https://git.openstack.org/openstack/neutron.git /opt/stack/neutron --branch rocky-eol --depth=1
git clone https://git.openstack.org/openstack/swift.git /opt/stack/swift --branch rocky-eol --depth=1
git clone https://git.openstack.org/openstack/horizon.git /opt/stack/horizon --branch rocky-eol --depth=1



# git clone https://git.openstack.org/openstack/tempest.git /opt/stack/tempest --branch 19.0.0 --depth=1
git clone https://git.openstack.org/openstack/tempest.git /opt/stack/tempest --branch 15.0.0 --depth=1
git clone https://git.openstack.org/novnc/noVNC.git /opt/stack/noVNC --branch stable/v0.6 --depth=1

cd /opt/stack/tempest
git checkout -b 21.0.0
cd /opt/stack

wget --progress=dot:giga -t 2 -c https://github.com/coreos/etcd/releases/download/v3.1.10/etcd-v3.1.10-linux-amd64.tar.gz -O /opt/stack/devstack/files/etcd-v3.1.10-linux-amd64.tar.gz

# sudo cp /home/app/etcd-v3.1.10-linux-amd64.tar.gz /opt/stack/devstack/files/etcd-v3.1.10-linux-amd64.tar.gz

cd devstack









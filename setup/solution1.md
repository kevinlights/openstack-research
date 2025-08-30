云平台搭建与部署
1
2
3
搭建和部署云平台是一个复杂的过程，需要多个步骤和配置。以下是一个详细的指南，介绍如何使用OpenStack搭建云平台。

基础环境准备

首先，需要准备两个节点：控制节点（controller）和计算节点（compute）。控制节点需要一块200G的硬盘和两块网卡，计算节点需要一块200G的硬盘和一块100G的硬盘，同样需要两块网卡。

控制节点配置

修改主机名和网卡配置：

hostnamectl set-hostname controller
vim /etc/sysconfig/network-scripts/ifcfg-eth0
# 修改为以下内容
TYPE=Ethernet
BOOTPROTO=static
NAME=eth0
DEVICE=eth0
ONBOOT=yes
IPADDR=192.168.100.10
NETMASK=255.255.255.0
GATEWAY=192.168.100.1
DNS1=8.8.8.8
关闭防火墙和SELinux：

systemctl stop firewalld
systemctl disable firewalld
setenforce 0
vim /etc/selinux/config
# 修改SELINUX=disabled
挂载镜像：

mount -o loop CentOS-7-x86_64-DVD-1804.iso /mnt
mkdir /opt/centos
cp -rf /mnt/* /opt/centos/
umount /mnt
配置YUM源：

cd /etc/yum.repos.d/
mv * /media/
vim local.repo
# 添加以下内容
[centos]
name=centos
baseurl=file:///opt/centos
gpgcheck=0
enabled=1
计算节点配置

计算节点的配置与控制节点类似，主要区别在于IP地址和硬盘分区。

正式搭建OpenStack云平台

安装必要的软件包

在控制节点上，安装必要的软件包：

yum install -y vim vsftpd iaas-xiandian
配置OpenStack组件

安装MySQL：

yum install mariadb mariadb-server python2-PyMySQL -y
systemctl enable mariadb.service
systemctl start mariadb.service
安装RabbitMQ：

yum install rabbitmq-server -y
systemctl enable rabbitmq-server.service
systemctl start rabbitmq-server.service
安装Keystone：

yum install openstack-keystone httpd mod_wsgi -y
安装Glance：

yum install openstack-glance -y
安装Nova：

yum install openstack-nova-api openstack-nova-conductor openstack-nova-console openstack-nova-novncproxy openstack-nova-scheduler -y
安装Neutron：

yum install openstack-neutron openstack-neutron-ml2 openstack-neutron-linuxbridge ebtables -y
启动和验证服务

启动各个服务并验证其状态：

systemctl enable openstack-nova-api.service openstack-nova-consoleauth.service openstack-nova-scheduler.service openstack-nova-conductor.service openstack-nova-novncproxy.service
systemctl start openstack-nova-api.service openstack-nova-consoleauth.service openstack-nova-scheduler.service openstack-nova-conductor.service openstack-nova-novncproxy.service
登录OpenStack云平台

在浏览器中输入http://192.168.100.10/dashboard，使用admin用户和密码登录，即可访问OpenStack云平台
1
。

通过以上步骤，您可以成功搭建和部署一个OpenStack云平台。

了解详细信息:
1 -
blog.csdn.net
2 -
blog.csdn.net
3 -
zhihu.com
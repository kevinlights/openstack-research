su - stack
cd /opt/stack/devstack


# https://www.voidking.com/dev-virtualbox-ubuntu-openstack/

stack@ubuntu:~/devstack$ ifconfig
# enp0s3    Link encap:Ethernet  HWaddr 08:00:27:f5:0d:99
#           inet addr:10.0.2.16  Bcast:10.0.2.255  Mask:255.255.255.0
#           inet6 addr: fe80::a00:27ff:fef5:d99/64 Scope:Link
#           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
#           RX packets:701 errors:0 dropped:0 overruns:0 frame:0
#           TX packets:1167 errors:0 dropped:0 overruns:0 carrier:0
#           collisions:0 txqueuelen:1000
#           RX bytes:52084 (52.0 KB)  TX bytes:141730 (141.7 KB)

# lo        Link encap:Local Loopback
#           inet addr:127.0.0.1  Mask:255.0.0.0
#           inet6 addr: ::1/128 Scope:Host
#           UP LOOPBACK RUNNING  MTU:65536  Metric:1
#           RX packets:160 errors:0 dropped:0 overruns:0 frame:0
#           TX packets:160 errors:0 dropped:0 overruns:0 carrier:0
#           collisions:0 txqueuelen:1
#           RX bytes:11840 (11.8 KB)  TX bytes:11840 (11.8 KB)

mkdir -p /opt/stack/logs

cat <<EOF | tee local.conf
[[local|localrc]]
MULTI_HOST=true
HOST_IP=10.0.2.16
LOGFILE=/opt/stack/logs/stack.sh.log

# Credentials
ADMIN_PASSWORD=admin
MYSQL_PASSWORD=secret
RABBIT_PASSWORD=secret
SERVICE_PASSWORD=secret
SERVICE_TOKEN=abcdefghijklmnopqrstuvwxyz

# service information
SERVICE_HOST=10.0.2.15
MYSQL_HOST=$SERVICE_HOST
RABBIT_HOST=$SERVICE_HOST
GLANCE_HOSTPORT=$SERVICE_HOST:9292
Q_HOST=$SERVICE_HOST
KEYSTONE_AUTH_HOST=$SERVICE_HOST
KEYSTONE_SERVICE_HOST=$SERVICE_HOST
CEILOMETER_BACKEND=mongodb
DATABASE_TYPE=mysql
ENABLED_SERVICES=n-cpu,q-agt,neutron
Q_AGENT=linuxbridge
ENABLE_TENANT_VLANS=True
TENANT_VLAN_RANGE=3001:4000
PHYSICAL_NETWORK=default

# vnc config
NOVA_VNC_ENABLED=True
NOVNCPROXY_URL="http://$SERVICE_HOST:6080/vnc_auto.html"
VNCSERVER_LISTEN=$HOST_IP
VNCSERVER_PROXYCLIENT_ADDRESS=$VNCSERVER_LISTEN

LOG_COLOR=False
LOGDIR=/opt/stack/logs
SCREEN_LOGDIR=$LOGDIR/screen

# Branches
KEYSTONE_BRANCH=queens-eol
NOVA_BRANCH=queens-eol
NEUTRON_BRANCH=queens-eol
SWIFT_BRANCH=queens-eol
GLANCE_BRANCH=queens-eol
CINDER_BRANCH=queens-eol
EOF

./stack.sh


cat /etc/network/interfaces

# # This file describes the network interfaces available on your system
# # and how to activate them. For more information, see interfaces(5).

# source /etc/network/interfaces.d/*

# # The loopback network interface
# auto lo
# iface lo inet loopback

# # The primary network interface
# auto enp0s3
# iface enp0s3 inet dhcp

# app@ubuntu:/dev$ ifconfig
# enp0s3    Link encap:Ethernet  HWaddr 08:00:27:f5:0d:99
#           inet addr:10.0.2.15  Bcast:10.0.2.255  Mask:255.255.255.0
#           inet6 addr: fe80::a00:27ff:fef5:d99/64 Scope:Link
#           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
#           RX packets:21 errors:0 dropped:0 overruns:0 frame:0
#           TX packets:27 errors:0 dropped:0 overruns:0 carrier:0
#           collisions:0 txqueuelen:1000
#           RX bytes:4220 (4.2 KB)  TX bytes:3376 (3.3 KB)

# lo        Link encap:Local Loopback
#           inet addr:127.0.0.1  Mask:255.0.0.0
#           inet6 addr: ::1/128 Scope:Host
#           UP LOOPBACK RUNNING  MTU:65536  Metric:1
#           RX packets:13853 errors:0 dropped:0 overruns:0 frame:0
#           TX packets:13853 errors:0 dropped:0 overruns:0 carrier:0
#           collisions:0 txqueuelen:1
#           RX bytes:17337296 (17.3 MB)  TX bytes:17337296 (17.3 MB)

# virbr0    Link encap:Ethernet  HWaddr 52:54:00:bb:92:d0
#           inet addr:192.168.122.1  Bcast:192.168.122.255  Mask:255.255.255.0
#           UP BROADCAST MULTICAST  MTU:1500  Metric:1
#           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
#           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
#           collisions:0 txqueuelen:1000
#           RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

sudo cp /etc/network/interfaces /etc/network/interfaces.bak

cat <<EOF | sudo tee /etc/network/interfaces
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto enp0s3
iface enp0s3 inet manual

auto br0
iface br0 inet dhcp
    bridge_stp off
    bridge_waitport 0
    bridge_fd 0
    bridge_ports enp0s3
EOF

sudo reboot

# app@ubuntu:~$ ifconfig
# br0       Link encap:Ethernet  HWaddr 08:00:27:f5:0d:99
#           inet addr:10.0.2.15  Bcast:10.0.2.255  Mask:255.255.255.0
#           inet6 addr: fe80::a00:27ff:fef5:d99/64 Scope:Link
#           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
#           RX packets:57 errors:0 dropped:0 overruns:0 frame:0
#           TX packets:77 errors:0 dropped:0 overruns:0 carrier:0
#           collisions:0 txqueuelen:1000
#           RX bytes:8870 (8.8 KB)  TX bytes:13706 (13.7 KB)

# enp0s3    Link encap:Ethernet  HWaddr 08:00:27:f5:0d:99
#           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
#           RX packets:57 errors:0 dropped:0 overruns:0 frame:0
#           TX packets:77 errors:0 dropped:0 overruns:0 carrier:0
#           collisions:0 txqueuelen:1000
#           RX bytes:9668 (9.6 KB)  TX bytes:13818 (13.8 KB)

# lo        Link encap:Local Loopback
#           inet addr:127.0.0.1  Mask:255.0.0.0
#           inet6 addr: ::1/128 Scope:Host
#           UP LOOPBACK RUNNING  MTU:65536  Metric:1
#           RX packets:160 errors:0 dropped:0 overruns:0 frame:0
#           TX packets:160 errors:0 dropped:0 overruns:0 carrier:0
#           collisions:0 txqueuelen:1
#           RX bytes:11840 (11.8 KB)  TX bytes:11840 (11.8 KB)

# virbr0    Link encap:Ethernet  HWaddr 52:54:00:bb:92:d0
#           inet addr:192.168.122.1  Bcast:192.168.122.255  Mask:255.255.255.0
#           UP BROADCAST MULTICAST  MTU:1500  Metric:1
#           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
#           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
#           collisions:0 txqueuelen:1000
#           RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)


brctl show

# bridge name     bridge id               STP enabled     interfaces
# br0             8000.080027f50d99       no              enp0s3
# virbr0          8000.525400bb92d0       yes             virbr0-nic



virsh list --all
#  Id    Name                           State
# ----------------------------------------------------
#  -     VM1                            shut off
#  -     VM2                            shut off
#  -     VM3                            shut off
#  -     VM4                            shut off



virsh start VM1


brctl show

# bridge name     bridge id               STP enabled     interfaces
# br0             8000.080027f50d99       no              enp0s3
#                                                         vnet0
# virbr0          8000.525400bb92d0       yes             virbr0-nic


virsh domiflist VM1
# Interface  Type       Source     Model       MAC
# -------------------------------------------------------
# vnet0      bridge     br0        rtl8139     52:54:00:ca:ce:65
virsh domiflist VM2

# Interface  Type       Source     Model       MAC
# -------------------------------------------------------
# -          bridge     br0        rtl8139     52:54:00:e9:00:67

# go to VM1
ifconfig
# eth0 10.0.2.8
ping 8.8.8.8
ping www.bing.com

# ok


# 将 VM1 的 nic 设置成 default NAT

brctl show
# bridge name     bridge id               STP enabled     interfaces
# br0             8000.080027f50d99       no              enp0s3
#                                                         vnet1
# virbr0          8000.525400bb92d0       yes             virbr0-nic
#                                                         vnet0


# app@ubuntu:~$ virsh domiflist VM1
# Interface  Type       Source     Model       MAC
# -------------------------------------------------------
# vnet0      network    default    rtl8139     52:54:00:78:be:94


ps -ef|grep dnsmasq

app@ubuntu:~$ ps -ef|grep dnsmasq
# libvirt+  1331     1  0 09:20 ?        00:00:00 /usr/sbin/dnsmasq --conf-file=/var/lib/libvirt/dnsmasq/default.conf --leasefile-ro --dhcp-script=/usr/lib/libvirt/libvirt_leaseshelper
# root      1332  1331  0 09:20 ?        00:00:00 /usr/sbin/dnsmasq --conf-file=/var/lib/libvirt/dnsmasq/default.conf --leasefile-ro --dhcp-script=/usr/lib/libvirt/libvirt_leaseshelper

app@ubuntu:/var/lib/libvirt/dnsmasq$ cat virbr0.status
# [
#     {
#         "ip-address": "192.168.122.225",
#         "mac-address": "52:54:00:78:be:94",
#         "hostname": "cirros",
#         "client-id": "01:52:54:00:78:be:94",
#         "expiry-time": 1755916269
#     }
# ]

app@ubuntu:/var/lib/libvirt/dnsmasq$ virsh console VM1
# Connected to domain VM1
# Escape character is ^]

# login as 'cirros' user. default password: 'cubswin:)'. use 'sudo' for root.
# cirros login: cirros
# Password:
$ ifconfig
# eth0      Link encap:Ethernet  HWaddr 52:54:00:78:BE:94
#           inet addr:192.168.122.225  Bcast:192.168.122.255  Mask:255.255.255.0
#           inet6 addr: fe80::5054:ff:fe78:be94/64 Scope:Link
#           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
#           RX packets:20 errors:0 dropped:0 overruns:0 frame:0
#           TX packets:103 errors:0 dropped:0 overruns:0 carrier:0
#           collisions:0 txqueuelen:1000
#           RX bytes:1750 (1.7 KiB)  TX bytes:7892 (7.7 KiB)
#           Interrupt:11 Base address:0xa000

# lo        Link encap:Local Loopback
#           inet addr:127.0.0.1  Mask:255.0.0.0
#           inet6 addr: ::1/128 Scope:Host
#           UP LOOPBACK RUNNING  MTU:16436  Metric:1
#           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
#           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
#           collisions:0 txqueuelen:0
#           RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

app@ubuntu:/var/lib/libvirt/dnsmasq$ ssh cirros@192.168.122.225
# cirros@192.168.122.225's password:
$ ifconfig
# eth0      Link encap:Ethernet  HWaddr 52:54:00:78:BE:94
#           inet addr:192.168.122.225  Bcast:192.168.122.255  Mask:255.255.255.0
#           inet6 addr: fe80::5054:ff:fe78:be94/64 Scope:Link
#           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
#           RX packets:75 errors:0 dropped:0 overruns:0 frame:0
#           TX packets:141 errors:0 dropped:0 overruns:0 carrier:0
#           collisions:0 txqueuelen:1000
#           RX bytes:9550 (9.3 KiB)  TX bytes:13560 (13.2 KiB)
#           Interrupt:11 Base address:0xa000

# lo        Link encap:Local Loopback
#           inet addr:127.0.0.1  Mask:255.0.0.0
#           inet6 addr: ::1/128 Scope:Host
#           UP LOOPBACK RUNNING  MTU:16436  Metric:1
#           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
#           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
#           collisions:0 txqueuelen:0
#           RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

$ ping www.bing.com
# PING www.bing.com (202.89.233.101): 56 data bytes
# 64 bytes from 202.89.233.101: seq=0 ttl=114 time=23.857 ms
# 64 bytes from 202.89.233.101: seq=1 ttl=114 time=22.856 ms
# 64 bytes from 202.89.233.101: seq=2 ttl=114 time=23.350 ms





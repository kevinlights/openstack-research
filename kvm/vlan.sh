

cat <<EOF | sudo tee /etc/network/interfaces
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto enp0s3
iface enp0s3 inet dhcp

auto enp0s3.10
iface enp0s3.10 inet manual
    vlan-raw-device enp0s3

auto brvlan10
iface brvlan10 inet manual
    bridge_stp off
    bridge_waitport 0
    bridge_fd 0
    bridge_ports enp0s3.10

auto enp0s3.20
iface enp0s3.20 inet manual
    vlan-raw-device enp0s3

auto brvlan20
iface brvlan20 inet manual
    bridge_stp off
    bridge_waitport 0
    bridge_fd 0
    bridge_ports enp0s3.20
EOF


sudo reboot

app@ubuntu:~$ ifconfig
# brvlan10  Link encap:Ethernet  HWaddr 08:00:27:f5:0d:99
#           inet6 addr: fe80::a00:27ff:fef5:d99/64 Scope:Link
#           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
#           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
#           TX packets:9 errors:0 dropped:0 overruns:0 carrier:0
#           collisions:0 txqueuelen:1000
#           RX bytes:0 (0.0 B)  TX bytes:758 (758.0 B)

# brvlan20  Link encap:Ethernet  HWaddr 08:00:27:f5:0d:99
#           inet6 addr: fe80::a00:27ff:fef5:d99/64 Scope:Link
#           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
#           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
#           TX packets:9 errors:0 dropped:0 overruns:0 carrier:0
#           collisions:0 txqueuelen:1000
#           RX bytes:0 (0.0 B)  TX bytes:758 (758.0 B)

# enp0s3    Link encap:Ethernet  HWaddr 08:00:27:f5:0d:99
#           inet addr:10.0.2.15  Bcast:10.0.2.255  Mask:255.255.255.0
#           inet6 addr: fe80::a00:27ff:fef5:d99/64 Scope:Link
#           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
#           RX packets:53 errors:0 dropped:0 overruns:0 frame:0
#           TX packets:95 errors:0 dropped:0 overruns:0 carrier:0
#           collisions:0 txqueuelen:1000
#           RX bytes:9306 (9.3 KB)  TX bytes:14828 (14.8 KB)

# enp0s3.10 Link encap:Ethernet  HWaddr 08:00:27:f5:0d:99
#           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
#           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
#           TX packets:10 errors:0 dropped:0 overruns:0 carrier:0
#           collisions:0 txqueuelen:1000
#           RX bytes:0 (0.0 B)  TX bytes:848 (848.0 B)

# enp0s3.20 Link encap:Ethernet  HWaddr 08:00:27:f5:0d:99
#           inet6 addr: fe80::a00:27ff:fef5:d99/64 Scope:Link
#           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
#           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
#           TX packets:18 errors:0 dropped:0 overruns:0 carrier:0
#           collisions:0 txqueuelen:1000
#           RX bytes:0 (0.0 B)  TX bytes:1516 (1.5 KB)

# lo        Link encap:Local Loopback
#           inet addr:127.0.0.1  Mask:255.0.0.0
#           inet6 addr: ::1/128 Scope:Host
#           UP LOOPBACK RUNNING  MTU:65536  Metric:1
#           RX packets:160 errors:0 dropped:0 overruns:0 frame:0
#           TX packets:160 errors:0 dropped:0 overruns:0 carrier:0
#           collisions:0 txqueuelen:1
#           RX bytes:11840 (11.8 KB)  TX bytes:11840 (11.8 KB)


app@ubuntu:~$ brctl show
# bridge name     bridge id               STP enabled     interfaces
# brvlan10                8000.080027f50d99       no              enp0s3.10
# brvlan20                8000.080027f50d99       no              enp0s3.20
# virbr0          8000.525400bb92d0       yes             virbr0-nic

app@ubuntu:~$ virsh list --all
#  Id    Name                           State
# ----------------------------------------------------
#  -     VM1                            shut off
#  -     VM2                            shut off
#  -     VM3                            shut off

app@ubuntu:~$ virsh domiflist VM1
# Interface  Type       Source     Model       MAC
# -------------------------------------------------------
# -          network    default    rtl8139     52:54:00:78:be:94


# virsh attach-interface <虚拟机名称> --type <网卡类型> --source <网络源> --model <网卡模型> --persistent
virsh attach-interface VM1 --type bridge --source brvlan10 --model rtl8139 --persistent


app@ubuntu:~$ virsh domiflist VM1
# Interface  Type       Source     Model       MAC
# -------------------------------------------------------
# -          network    default    rtl8139     52:54:00:78:be:94
# -          bridge     brvlan10   rtl8139     52:54:00:67:41:92


virsh edit VM1
#    <interface type='network'>
#      <source network='default'/>  <!-- 修改为 bridge='br0' 或其他网络名称 -->
#    </interface>


# virsh detach-interface <虚拟机名称> --type <网卡类型> --mac <MAC地址>
# virsh detach-interface VM1 --mac 52:54:00:78:be:94 --type network


app@ubuntu:~$ virsh domiflist VM1
# Interface  Type       Source     Model       MAC
# -------------------------------------------------------
# -          bridge     brvlan10   rtl8139     52:54:00:67:41:92

app@ubuntu:~$ virsh start VM1
# Domain VM1 started

app@ubuntu:~$ brctl show
# bridge name     bridge id               STP enabled     interfaces
# brvlan10                8000.080027f50d99       no              enp0s3.10
#                                                         vnet0
# brvlan20                8000.080027f50d99       no              enp0s3.20
# virbr0          8000.525400bb92d0       yes             virbr0-nic
app@ubuntu:~$ virsh domiflist VM1
# Interface  Type       Source     Model       MAC
# -------------------------------------------------------
# vnet0      bridge     brvlan10   rtl8139     52:54:00:67:41:92

app@ubuntu:~$ virsh domiflist VM2
# Interface  Type       Source     Model       MAC
# -------------------------------------------------------
# -          bridge     brvlan20   rtl8139     52:54:00:25:c8:61

app@ubuntu:~$ virsh start VM2
# Domain VM2 started

app@ubuntu:~$ brctl show
# bridge name     bridge id               STP enabled     interfaces
# brvlan10                8000.080027f50d99       no              enp0s3.10
#                                                         vnet0
# brvlan20                8000.080027f50d99       no              enp0s3.20
#                                                         vnet1
# virbr0          8000.525400bb92d0       yes             virbr0-nic
app@ubuntu:~$ virsh domiflist VM2
# Interface  Type       Source     Model       MAC
# -------------------------------------------------------
# vnet1      bridge     brvlan20   rtl8139     52:54:00:25:c8:61


app@ubuntu:~$ virsh console VM1
# Connected to domain VM1
# Escape character is ^]

# login as 'cirros' user. default password: 'cubswin:)'. use 'sudo' for root.
# cirros login: cirros
# Password:
$ ifconfig
# eth0      Link encap:Ethernet  HWaddr 52:54:00:67:41:92
#           inet6 addr: fe80::5054:ff:fe67:4192/64 Scope:Link
#           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
#           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
#           TX packets:9 errors:0 dropped:0 overruns:0 carrier:0
#           collisions:0 txqueuelen:1000
#           RX bytes:0 (0.0 B)  TX bytes:1464 (1.4 KiB)
#           Interrupt:11 Base address:0xa000

# lo        Link encap:Local Loopback
#           inet addr:127.0.0.1  Mask:255.0.0.0
#           inet6 addr: ::1/128 Scope:Host
#           UP LOOPBACK RUNNING  MTU:16436  Metric:1
#           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
#           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
#           collisions:0 txqueuelen:0
#           RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

$ sudo ifconfig eth0 192.168.100.10/24 up
$ ifconfig
# eth0      Link encap:Ethernet  HWaddr 52:54:00:67:41:92
#           inet addr:192.168.100.10  Bcast:192.168.100.255  Mask:255.255.255.0
#           inet6 addr: fe80::5054:ff:fe67:4192/64 Scope:Link
#           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
#           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
#           TX packets:9 errors:0 dropped:0 overruns:0 carrier:0
#           collisions:0 txqueuelen:1000
#           RX bytes:0 (0.0 B)  TX bytes:1464 (1.4 KiB)
#           Interrupt:11 Base address:0xa000

# lo        Link encap:Local Loopback
#           inet addr:127.0.0.1  Mask:255.0.0.0
#           inet6 addr: ::1/128 Scope:Host
#           UP LOOPBACK RUNNING  MTU:16436  Metric:1
#           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
#           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
#           collisions:0 txqueuelen:0
#           RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)


app@ubuntu:~$ virsh console VM3
# Connected to domain VM3
# Escape character is ^]

# login as 'cirros' user. default password: 'cubswin:)'. use 'sudo' for root.
# cirros login: cirros
# Password:
$ ifconfig
# eth0      Link encap:Ethernet  HWaddr 52:54:00:AD:77:07
#           inet6 addr: fe80::5054:ff:fead:7707/64 Scope:Link
#           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
#           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
#           TX packets:9 errors:0 dropped:0 overruns:0 carrier:0
#           collisions:0 txqueuelen:1000
#           RX bytes:0 (0.0 B)  TX bytes:1434 (1.4 KiB)
#           Interrupt:11 Base address:0xa000

# lo        Link encap:Local Loopback
#           inet addr:127.0.0.1  Mask:255.0.0.0
#           inet6 addr: ::1/128 Scope:Host
#           UP LOOPBACK RUNNING  MTU:16436  Metric:1
#           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
#           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
#           collisions:0 txqueuelen:0
#           RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

$ sudo ifconfig eth0 192.168.100.20/24 up
$ ifconfig
# eth0      Link encap:Ethernet  HWaddr 52:54:00:AD:77:07
#           inet addr:192.168.100.20  Bcast:192.168.100.255  Mask:255.255.255.0
#           inet6 addr: fe80::5054:ff:fead:7707/64 Scope:Link
#           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
#           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
#           TX packets:9 errors:0 dropped:0 overruns:0 carrier:0
#           collisions:0 txqueuelen:1000
#           RX bytes:0 (0.0 B)  TX bytes:1434 (1.4 KiB)
#           Interrupt:11 Base address:0xa000

# lo        Link encap:Local Loopback
#           inet addr:127.0.0.1  Mask:255.0.0.0
#           inet6 addr: ::1/128 Scope:Host
#           UP LOOPBACK RUNNING  MTU:16436  Metric:1
#           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
#           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
#           collisions:0 txqueuelen:0
#           RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)


# $ ping 192.168.100.10
# PING 192.168.100.10 (192.168.100.10): 56 data bytes

# --- 192.168.100.10 ping statistics ---
# 4 packets transmitted, 0 packets received, 100% packet loss
# $ ping 192.168.100.20
# PING 192.168.100.20 (192.168.100.20): 56 data bytes
# 64 bytes from 192.168.100.20: seq=0 ttl=64 time=0.097 ms
# 64 bytes from 192.168.100.20: seq=1 ttl=64 time=0.030 ms

# --- 192.168.100.20 ping statistics ---
# 2 packets transmitted, 2 packets received, 0% packet loss
# round-trip min/avg/max = 0.030/0.063/0.097 ms
# $ ip route
# 192.168.100.0/24 dev eth0  src 192.168.100.20




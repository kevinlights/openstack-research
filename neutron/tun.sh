ip tunnel help

cat /proc/sys/net/ipv4/ip_forward

echo "1" > /proc/sys/net/ipv4/ip_forward

# vim /etc/sysctl.conf
# net.ipv4.ip_forward=1

ip link add tap1 type veth peer name tap1_peer
ip link add tap2 type veth peer name tap2_peer

ip netns add ns1
ip netns add ns2

ip link set tap1 netns ns1
ip link set tap2 netns ns2

ifconfig tap1_peer 192.168.100.1/24 up
ifconfig tap2_peer 192.168.200.1/24 up

ip netns exec ns1 ifconfig tap1 192.168.100.2/24 up
ip netns exec ns2 ifconfig tap2 192.168.200.2/24 up

ip a

ip netns exec ns1 ping 192.168.200.2

ip netns exec ns1 ip route
ip netns exec ns1 route -nee

ip netns exec ns1 route add -net 192.168.200.0 netmask 255.255.255.0 gw 192.168.100.1
ip netns exec ns2 route add -net 192.168.100.0 netmask 255.255.255.0 gw 192.168.200.1

ip netns exec ns1 ping -c 1 192.168.200.2
ip netns exec ns1 traceroute 192.168.200.2
ip netns exec ns2 ping -c 1 192.168.100.2

modprobe ipip
lsmod | grep ip
# ipip                   20480  0
# tunnel4                16384  1 ipip
# ip_tunnel              32768  1 ipip
# dm_multipath           40960  0
# ip_tables              32768  0
# x_tables               53248  1 ip_tables
# multipath              20480  0

ip netns exec ns1 ip tunnel add tun1 mode ipip remote 192.168.200.2 local 192.168.100.2 ttl 255
ip netns exec ns1 ip link set tun1 up
ip netns exec ns1 ip addr add 192.168.50.10 peer 192.168.60.10 dev tun1
ip netns exec ns1 ip a

ip netns exec ns2 ip tunnel add tun2 mode ipip remote 192.168.100.2 local 192.168.200.2 ttl 255
ip netns exec ns2 ip link set tun2 up
ip netns exec ns2 ip addr add 192.168.60.10 peer 192.168.50.10 dev tun2
ip netns exec ns2 ip a

ip netns exec ns1 ping -c 3 192.168.60.10
ip netns exec ns2 ping -c 3 192.168.50.10

ip netns exec ns1 ifconfig
ip netns exec ns1 route -nee
ip netns exec ns1 traceroute 192.168.60.10



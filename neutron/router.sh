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

ip netns exec ns1 ping 192.168.200.2
ip netns exec ns1 traceroute 192.168.200.2

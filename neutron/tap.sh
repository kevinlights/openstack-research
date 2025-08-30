modinfo tun
lsmod | grep tun
modprobe tun
cat /proc/cpuinfo | grep vmx

sudo apt install uml-utilities net-tools bridge-utils

tunctl help
tunctl -t tap_test
ip link list
ifconfig -a

ip addr add local 192.168.100.1/24 dev tap_test

ip netns help
ip netns list
ip netns add ns_test
ip netns list
ip link set tap_test netns ns_test
ip netns exec ns_test ip link list
ip netns exec ns_test ifconfig -a

ip link add tap1 type veth peer name tap2
ip netns add ns1
ip netns add ns2
ip link set tap1 netns ns1
ip link set tap2 netns ns2
ip netns exec ns1 ifconfig tap1 192.168.50.1/24 up
ip netns exec ns2 ifconfig tap2 192.168.50.2/24 up
ip netns exec ns2 ifconfig -a
ip netns exec ns1 ping 192.168.50.2
ip netns exec ns2 ping 192.168.50.1


ip netns delete ns1
ip netns delete ns2

brctl

ip link add tap1 type veth peer name tap1_peer
ip link add tap2 type veth peer name tap2_peer
ip link add tap3 type veth peer name tap3_peer
ip link add tap4 type veth peer name tap4_peer
ip netns add ns1
ip netns add ns2
ip netns add ns3
ip netns add ns4
ip link set tap1 netns ns1
ip link set tap2 netns ns2
ip link set tap3 netns ns3
ip link set tap4 netns ns4

brctl addbr br1
brctl addif br1 tap1_peer
brctl addif br1 tap2_peer
brctl addif br1 tap3_peer
brctl addif br1 tap4_peer
ip netns exec ns1 ifconfig tap1 192.168.50.1/24 up
ip netns exec ns2 ifconfig tap2 192.168.50.2/24 up
ip netns exec ns3 ifconfig tap3 192.168.50.3/24 up
ip netns exec ns4 ifconfig tap4 192.168.50.4/24 up
ip link set br1 up
ip link set tap1_peer up
ip link set tap2_peer up
ip link set tap3_peer up
ip link set tap4_peer up

ip netns exec ns1 ping -c 3 192.168.50.2
ip netns exec ns1 ping -c 3 192.168.50.3
ip netns exec ns1 ping -c 3 192.168.50.4




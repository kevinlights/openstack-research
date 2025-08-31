

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



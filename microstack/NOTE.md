# Notes


## must modify hosts

```shell

app@ubuntu:~$ ifconfig
br-ex     Link encap:Ethernet  HWaddr da:9b:59:85:27:41
          inet addr:10.20.20.1  Bcast:0.0.0.0  Mask:255.255.255.0
          inet6 addr: fe80::d89b:59ff:fe85:2741/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:11 errors:0 dropped:0 overruns:0 frame:0
          TX packets:14 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1
          RX bytes:308 (308.0 B)  TX bytes:1060 (1.0 KB)

enp0s3    Link encap:Ethernet  HWaddr 08:00:27:f5:0d:99
          inet addr:10.0.2.15  Bcast:10.0.2.255  Mask:255.255.255.0
          inet6 addr: fe80::a00:27ff:fef5:d99/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:8586 errors:0 dropped:0 overruns:0 frame:0
          TX packets:15056 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:728618 (728.6 KB)  TX bytes:16120894 (16.1 MB)

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:71527 errors:0 dropped:0 overruns:0 frame:0
          TX packets:71527 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1
          RX bytes:53268494 (53.2 MB)  TX bytes:53268494 (53.2 MB)


app@ubuntu:~$ cat /etc/hosts
127.0.0.1       localhost
127.0.0.1       ubuntu.myguest.virtualbox.org   ubuntu
10.0.2.15       ubuntu.myguest.virtualbox.org   ubuntu

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters

```


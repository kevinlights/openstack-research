

ifconfig -a
# dhclient enp0s8
ifconfig
sudo service ssh start

# https://www.oryoy.com/news/ubuntu-16-04-ssh-fu-wu-zi-qi-dong-pei-zhi-quan-gong-lve-qing-song-shi-xian-yuan-cheng-deng-lu-wu-you-a14611105.html
sudo systemctl enable ssh



# install kvm packages
sudo apt install qemu-kvm qemu-system libvirt-bin virt-manager bridge-utils vlan

# 593MB

# enable x11 forwarding
# https://linuxconfig.org/how-to-enable-x11-forwarding-on-linux
sudo nano /etc/ssh/sshd_config
# Look for a line that says X11Forwarding yes. If it is commented out or set to no, change it to yes and save the file
# check by running `xclock`

sudo apt install xterm
xterm -sb -fa 'Monospace' -fs 12 &

# install desktop
# sudo apt install xinit gdm kubuntu-desktop

# Virtual Box启用嵌套VT-x/AMD-v灰色终极解决办法
# 1. bios 打开 cpu 虚拟化
# 2. 关闭 windows 沙盒，hype-v，虚拟机平台，重启
# 3. 内核隔离中，关闭内存完整性

D:\DevTools\VirtualBox>VBoxManage.exe list vms
"GNS3 VM" {fb93d20f-15ac-4187-8412-866af58e1f87}
"CentOS7_100G_docker20" {ebcbb4d5-9325-453f-88d2-6c8679a6ce31}
"ubuntu2204" {b376d6e1-36bd-409a-b81a-a1d7d9a76c85}
"ubuntu1604" {ca5cb97e-8945-4765-be4b-ded587543304}

D:\DevTools\VirtualBox>VBoxManage.exe modifyvm ubuntu1604 --nested-hw-virt on

restart virtual box

start vm

egrep -o '(vmx|svm)' /proc/cpuinfo
# expect vmx


service libvirt-bin status

virt-manager

# https://download.cirros-cloud.net/
sudo ls /var/lib/libvirt/images/
wget https://download.cirros-cloud.net/0.6.3/cirros-0.6.3-x86_64-disk.img
# sudo mv cirros-0.6.3-x86_64-disk.img /var/lib/libvirt/images/
wget https://download.cirros-cloud.net/0.3.0/cirros-0.3.0-x86_64-disk.img
wget https://download.cirros-cloud.net/0.3.3/cirros-0.3.3-x86_64-disk.img
sudo cp ~/cirros-0.3.3-x86_64-disk.img /var/lib/libvirt/images/vm1.img
sudo cp ~/cirros-0.3.3-x86_64-disk.img /var/lib/libvirt/images/vm2.img

sudo cp ~/cirros-0.3.0-x86_64-disk.img /var/lib/libvirt/images/vm3.img
sudo cp ~/cirros-0.3.0-x86_64-disk.img /var/lib/libvirt/images/vm4.img

virsh list

# app@ubuntu:~$ ps -ef | grep generic
# libvirt+  5111     1 99 22:12 ?        00:04:04 qemu-system-x86_64 -enable-kvm -name generic -S -machine pc-i440fx-xenial,accel=kvm,usb=off -cpu Westmere -m 100 -realtime mlock=off -smp 1,sockets=1,cores=1,threads=1 -uuid 3c5f0e5b-ee60-484f-8cf7-a59f408458a0 -no-user-config -nodefaults -chardev socket,id=charmonitor,path=/var/lib/libvirt/qemu/domain-generic/monitor.sock,server,nowait -mon chardev=charmonitor,id=monitor,mode=control -rtc base=utc,driftfix=slew -global kvm-pit.lost_tick_policy=discard -no-hpet -no-shutdown -global PIIX4_PM.disable_s3=1 -global PIIX4_PM.disable_s4=1 -boot strict=on -device ich9-usb-ehci1,id=usb,bus=pci.0,addr=0x6.0x7 -device ich9-usb-uhci1,masterbus=usb.0,firstport=0,bus=pci.0,multifunction=on,addr=0x6 -device ich9-usb-uhci2,masterbus=usb.0,firstport=2,bus=pci.0,addr=0x6.0x1 -device ich9-usb-uhci3,masterbus=usb.0,firstport=4,bus=pci.0,addr=0x6.0x2 -device virtio-serial-pci,id=virtio-serial0,bus=pci.0,addr=0x5 -drive file=/var/lib/libvirt/images/cirros-0.6.3-x86_64-disk.img,format=qcow2,if=none,id=drive-ide0-0-0 -device ide-hd,bus=ide.0,unit=0,drive=drive-ide0-0-0,id=ide0-0-0,bootindex=1 -netdev tap,fd=26,id=hostnet0 -device rtl8139,netdev=hostnet0,id=net0,mac=52:54:00:8f:b2:4c,bus=pci.0,addr=0x3 -chardev pty,id=charserial0 -device isa-serial,chardev=charserial0,id=serial0 -chardev spicevmc,id=charchannel0,name=vdagent -device virtserialport,bus=virtio-serial0.0,nr=1,chardev=charchannel0,id=channel0,name=com.redhat.spice.0 -spice port=5900,addr=127.0.0.1,disable-ticketing,image-compression=off,seamless-migration=on -device qxl-vga,id=video0,ram_size=67108864,vram_size=67108864,vgamem_mb=16,bus=pci.0,addr=0x2 -device intel-hda,id=sound0,bus=pci.0,addr=0x4 -device hda-duplex,id=sound0-codec0,bus=sound0.0,cad=0 -chardev spicevmc,id=charredir0,name=usbredir -device usb-redir,chardev=charredir0,id=redir0 -chardev spicevmc,id=charredir1,name=usbredir -device usb-redir,chardev=charredir1,id=redir1 -device virtio-balloon-pci,id=balloon0,bus=pci.0,addr=0x7 -msg timestamp=on


# https://cloud-images.ubuntu.com/minimal/releases/
wget https://cloud-images.ubuntu.com/minimal/releases/bionic/release/ubuntu-18.04-minimal-cloudimg-amd64.img
sudo cp ubuntu-18.04-minimal-cloudimg-amd64.img /var/lib/libvirt/images/vm3.img

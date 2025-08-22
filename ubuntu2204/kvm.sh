
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


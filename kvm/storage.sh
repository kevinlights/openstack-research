

sudo ls /var/lib/libvirt/images
ls /etc/libvirt/storage
sudo cat /etc/libvirt/storage/default.xml
# <!--
# WARNING: THIS IS AN AUTO-GENERATED FILE. CHANGES TO IT ARE LIKELY TO BE
# OVERWRITTEN AND LOST. Changes to this xml configuration should be made using:
#   virsh pool-edit default
# or other application using the libvirt API.
# -->

# <pool type='dir'>
#   <name>default</name>
#   <uuid>ffd59c33-7bf9-40c0-bd2d-2a8ea2c9b7d3</uuid>
#   <capacity unit='bytes'>0</capacity>
#   <allocation unit='bytes'>0</allocation>
#   <available unit='bytes'>0</available>
#   <source>
#   </source>
#   <target>
#     <path>/var/lib/libvirt/images</path>
#   </target>
# </pool>


sudo apt install lvm2

sudo service lvm2-lvmetad start
sudo service lvm2-* start


sudo vgdisplay

# 在 virtualbox 中，给 vm 添加虚拟硬盘
# shutdown
# settings -> storage -> controller -> add hard disk

ls /dev
lsblk
sudo fdisk -l

sudo fdisk /dev/sdb
# n, p, 1, w

sudo pvcreate /dev/sdb1
#  Physical volume "/dev/sdb1" successfully created


sudo vgcreate -v HostVG /dev/sdb1
#     Adding physical volume '/dev/sdb1' to volume group 'HostVG'
#     Creating directory "/etc/lvm/archive"
#     Archiving volume group "HostVG" metadata (seqno 0).
#     Creating directory "/etc/lvm/backup"
#     Creating volume group backup "/etc/lvm/backup/HostVG" (seqno 1).
#   Volume group "HostVG" successfully created


# app@ubuntu:~$ sudo vgdisplay
#   --- Volume group ---
#   VG Name               HostVG
#   System ID
#   Format                lvm2
#   Metadata Areas        1
#   Metadata Sequence No  1
#   VG Access             read/write
#   VG Status             resizable
#   MAX LV                0
#   Cur LV                0
#   Open LV               0
#   Max PV                0
#   Cur PV                1
#   Act PV                1
#   VG Size               1.56 GiB
#   PE Size               4.00 MiB
#   Total PE              399
#   Alloc PE / Size       0 / 0
#   Free  PE / Size       399 / 1.56 GiB
#   VG UUID               T1VmJ7-93FE-MmXQ-MqNe-h4wY-0Spz-WiX10t


# app@ubuntu:~$ sudo vgs
#   VG     #PV #LV #SN Attr   VSize VFree
#   HostVG   1   0   0 wz--n- 1.56g 1.56g




cat <<EOF | sudo tee /etc/libvirt/storage/HostVG.xml
<pool type='logical'>
  <name>HostVG</name>
  <source>
    <name>HostVG</name>
    <format type="lvm2" />
  </source>
  <target>
    <path>/dev/HostVG</path>
  </target>
</pool>
EOF

virsh pool-list --all
#  Name                 State      Autostart
# -------------------------------------------
#  default              active     yes

virsh pool-define /etc/libvirt/storage/HostVG.xml
# Pool HostVG defined from /etc/libvirt/storage/HostVG.xml

virsh pool-list --all
#  Name                 State      Autostart
# -------------------------------------------
#  default              active     yes
#  HostVG               inactive   no

virsh pool-start HostVG
# Pool HostVG started





# Init Ubuntu 16.04


## openssh 

```shell
sudo apt install openssh-server
sudo server ssh start
sudo server ssh status
# sudo sysv-rc-conf
# check ssh 2,3,4,5
```

## apt source

**Reference**:
* https://mirrors.tuna.tsinghua.edu.cn/help/ubuntu/
* https://www.cnblogs.com/EasonJim/p/7189509.html


```shell
sudo mv /etc/apt/sources.list /etc/apt/sources.list.bak

cat | sudo tee /etc/apt/sources.list <<EOF
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial main restricted universe multiverse
# deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-updates main restricted universe multiverse
# deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-updates main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-backports main restricted universe multiverse
# deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-backports main restricted universe multiverse

# 以下安全更新软件源包含了官方源与镜像站配置，如有需要可自行修改注释切换
deb http://security.ubuntu.com/ubuntu/ xenial-security main restricted universe multiverse
# deb-src http://security.ubuntu.com/ubuntu/ xenial-security main restricted universe multiverse

# 预发布软件源，不建议启用
# deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-proposed main restricted universe multiverse
# # deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-proposed main restricted universe multiverse
EOF

sudo apt update

```


## virtual box 配置
在 VirtualBox 中为 Ubuntu 虚拟机配置一张网卡同时满足以下两个需求，可以通过以下步骤实现：

解决方案：使用 NAT 网络 + 端口转发
（单网卡同时支持 SSH 和互联网访问）

1. 配置虚拟机的网络模式
打开 VirtualBox，选择你的 Ubuntu 虚拟机 -> 设置 -> 网络。
确保只有 一个网卡（如 网卡1）被启用，并选择以下配置：
连接方式: NAT 网络（不是默认的 NAT，而是 NAT 网络）
如果没有 NAT 网络 选项，需先在 VirtualBox 全局设置中创建：
VirtualBox 主界面 -> 管理 -> 全局设定 -> 网络 -> 添加 NAT 网络（默认名称 NatNetwork）。
高级 -> 端口转发：
添加一条规则：
名称: SSH（任意）
协议: TCP
主机IP: 留空（或填 127.0.0.1）
主机端口: 2222（或其他未被占用的端口）
客户机IP: 留空（或填虚拟机的局域网 IP，如 10.0.2.15）
客户机端口: 22

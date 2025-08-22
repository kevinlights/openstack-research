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

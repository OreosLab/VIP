# jd_v4

## CentOS 安装 docker

centos8.2以下的如果部署不成功，先重置服务器，再升级一下内核就可以了

### 升级内核命令

```sh
sudo yum update
```

### 安装依赖

```sh
sudo yum install -y yum-utils device-mapper-persistent-data lvm2

wget -O /etc/yum.repos.d/docker-ce.repo https://download.docker.com/linux/centos/docker-ce.repo

sudo sed -i 's+download.docker.com+mirrors.tuna.tsinghua.edu.cn/docker-ce+' /etc/yum.repos.d/docker-ce.repo
```

### 安装

```sh
sudo yum makecache fast
```

### 安装过 docker 忽略

```sh
sudo yum install docker-ce
```

### 启动并加入开机启动

```sh
sudo systemctl start docker

sudo systemctl enable docker
```

### 换源

#### 腾讯云用腾讯云的

```sh
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
"registry-mirrors": ["https://mirror.ccs.tencentyun.com"]
}
EOF
```

#### 阿里云服务器 用网易的加速器

```sh
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
"registry-mirrors": ["http://hub-mirror.c.163.com"]
}
EOF
```

### 重启docker

```sh
sudo service docker restart
```

### 卸载Docker

```sh
sudo yum remove docker docker-common docker-selinux docker-engine
```

### 安装过 docker 同样忽略

```sh
sudo docker pull  nevinee/jd:v4
```

## Docker 部署京东脚本

### e大v4部署

```sh
docker run -dit \
    -v /jd/config:/jd/config \
    -v /jd/log:/jd/log \
    -v /jd/scripts:/jd/scripts \
    -v /jd/own:/jd/own \
    -p 5678:5678 \
    -e ENABLE_HANGUP=true \
    -e ENABLE_WEB_PANEL=true \
    -e ENABLE_WEB_TTYD=true \
    --name jd \
    --hostname jd \
    --restart always \
    nevinee/jd:v4
```

### 多容器配置 - 安装过shuye等占用jd容器名或者调整目录使用

要想换库直接改最后一行

```sh
docker run -dit \
    -v /你想保存的目录/jd1/config:/jd/config `# 配置保存目录，冒号左边请修改为你想存放的路径`\
    -v /你想保存的目录/jd1/log:/jd/log `# 日志保存目录，冒号左边请修改为你想存放的路径` \
    -v /你想保存的目录/jd1/scripts:/jd/scripts `# 脚本文件目录，映射脚本文件到安装路径` \
    -v /jd/own:/jd/own \
    -p 5679:5678 \
    -e ENABLE_HANGUP=true \
    -e ENABLE_WEB_PANEL=true \
    -e ENABLE_WEB_TTYD=true \
    --name jd1 \
    --hostname jd1 \
    --restart always \
    nevinee/jd:v4
```

### 自动更新Docker容器（也就是更新京东文件）

v4更新命令

```sh
docker exec -it jd1 bash jup
```

## 安装v4面板

### 开启DIY每次重启会重启面板

### 先进入容器

```sh
docker exec -it jd1 bash

wget -q https://ghproxy.com/https://raw.githubusercontent.com/jiulan/jd_v4/main/v4mb.sh -O v4mb.sh && chmod +x v4mb.sh && ./v4mb.sh
```

### 重启手动运行面板

### 进入容器

```sh
cd panel

npm i

pm2 start server.js
```

### 页面访问

-p 宿主机端口: 容器内端口

-p A: A 内外同端口

-p B: A 异端口

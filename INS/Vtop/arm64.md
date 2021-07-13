# 【V2P】V2P攻略补完计划，N1路由器等arm64架构设备安装v2p的方法说明


## 第一章：安装docker

这是基础步骤，

怎么也少不了的。

我就照抄前面教程的第一章了，没有任何区别。

首先使用任意你喜欢的shell工具链接你的设备，这个应该都会的。

linux电脑直接终端跑就可以。

然后使用下面的安装命令：

``` sh
curl -sSL https://get.daocloud.io/docker | sh
```

如果安装顺利，直接看第二章去。

如果遇到了各种报错问题，可以参考下面的解决办法：

1、如果输入命令后提示：-bash: curl：未找到命令

``` sh
apt-get update
apt-get install curl
```

2、如果提示权限不够，输入下面命令，并输入管理员密码启用root权限

``` sh
su
```

3、如果提示下载失败，可以百度如何更换软件源。换个清华源、阿里源之类的再重新来。不再废话。


## 第二章：拉取v2p

docker顺利安装后，

直接复制我下方全部代码，

一次性粘贴进去并回车

【注意，这里是说的本文这个arm64架构设备的拉取方法，包括n1、树莓、部分linux电脑等，不是arm64的还是看原来的教程】

``` sh
docker run --restart=always \
  -d --name elecv2p \
  -e TZ=Asia/Shanghai \
  -p 8100:80 -p 8101:8001 -p 8102:8002 \
  -v /elecv2p/JSFile:/usr/local/app/script/JSFile \
  -v /elecv2p/Lists:/usr/local/app/script/Lists \
  -v /elecv2p/Store:/usr/local/app/script/Store \
  -v /elecv2p/Shell:/usr/local/app/script/Shell \
  -v /elecv2p/rootCA:/usr/local/app/rootCA \
  -v /elecv2p/efss:/usr/local/app/efss \
  elecv2/elecv2p:arm64
```

至此就完事了。


## 第三章  进入v2p

有外网ip的使用

`ip:8100`

访问v2p主页。


本地设备安装的，比如linux电脑，

使用

```
127.0.0.1:8100
```

如果进入面板不正确，检查自己的防火墙是否放行了V2P所需的端口。


如80 81 82 8100 8101 8102 443

进入后，怎么玩儿的问题之前的教程已经说的很细了。


之前没来得及展开说的直接抓包之类的问题，

我们下篇文章再说。

晚安大家。

## 原文链接
> https://mp.weixin.qq.com/s/bzBfinEh4yOX6AjA3xwPgw

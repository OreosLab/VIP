# V2P安装教程

## 一、安装docker

``` sh
curl -sSL https://get.daocloud.io/docker | sh
```

## 二、安装docker compose

下面2条命令分2次粘贴并回车

``` sh
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```
``` sh
sudo chmod +x /usr/local/bin/docker-compose
```

## 三、拉取v2p

下面3条命令分3次粘贴并回车

``` sh
mkdir /elecv2p && cd /elecv2p
```
``` sh
curl -sL https://git.io/JLw7s > docker-compose.yaml
```
``` sh
docker-compose up -d
```

## 四、打开v2p

确保你的设备放行了`80` `81` `82` `8100` `8101` `8102` 端口

用你设备的`ip:8100`登录v2p

## 五、添加脚本订阅

在v2p的task页面中订阅我的脚本地址（加订阅和从订阅中加脚本方式都和圈x里一样，点击就行）

`https://raw.githubusercontent.com/sngxpro/QuanX/master/V2PTaskSub/sngxprov2p.json`

## 六、用姐姐的手机cookie自动同步v2p脚本，将手机的cookie同步到v2p

[图文教程](https://mp.weixin.qq.com/s/jZNFR3qszbEuc9nM43WeqA)


## 完事收工

- 公众号少年歌行pro
> 教程 https://t.me/shao66

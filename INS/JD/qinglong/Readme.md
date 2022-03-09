# 青龙安装教程

## 一、安装docker

``` sh
curl -sSL https://get.daocloud.io/docker | sh
```

## 二、拉取青龙

### 1. 拉取镜像/更新镜像

``` sh
docker pull whyour/qinglong:latest
```

### 2. 启动容器

#### 2-1 普通服务器

``` sh
docker run -dit \
  -v $PWD/ql/config:/ql/config \
  -v $PWD/ql/db:/ql/db \
  -v $PWD/ql/log:/ql/log \
  -v $PWD/ql/repo:/ql/repo \
  -v $PWD/ql/raw:/ql/raw \
  -v $PWD/ql/scripts:/ql/scripts \
  -v $PWD/ql/jbot:/ql/jbot \
  -p 5700:5700 \
  -e ENABLE_HANGUP=true \
  -e ENABLE_TG_BOT=true \
  -e ENABLE_WEB_PANEL=true \
  -e TZ=CST-8 \
  --name qinglong \
  --hostname qinglong \
  --restart always \
  whyour/qinglong:latest
```

#### 2-2 N1等路由器

``` sh
docker run -dit \
  -v $PWD/ql/config:/ql/config \
  -v $PWD/ql/db:/ql/db \
  -v $PWD/ql/log:/ql/log \
  -v $PWD/ql/repo:/ql/repo \
  -v $PWD/ql/raw:/ql/raw \
  -v $PWD/ql/scripts:/ql/scripts \
  -v $PWD/ql/jbot:/ql/jbot \
  -e ENABLE_HANGUP=true \
  -e ENABLE_TG_BOT=true \
  -e ENABLE_WEB_PANEL=true \
  -e TZ=CST-8 \
  --net host \
  --name qinglong \
  --hostname qinglong \
  --restart always \
  whyour/qinglong:latest
```

#### 2-3 MacVlan方式

``` sh
docker run -dit \
  --name qinglong \
  --hostname qinglong \
  --restart always \
  --net=macnet \
  --ip=192.168.2.20 \
  --dns=192.168.2.2 \
  --mac-address C2:F2:9C:C5:B1:01 \
  -v $PWD/ql/config:/ql/config \
  -v $PWD/ql/db:/ql/db \
  -v $PWD/ql/log:/ql/log \
  -v $PWD/ql/repo:/ql/repo \
  -v $PWD/ql/raw:/ql/raw \
  -v $PWD/ql/scripts:/ql/scripts \
  -v $PWD/ql/jbot:/ql/jbot \
  -e ENABLE_HANGUP=true \
  -e ENABLE_TG_BOT=true \
  -e ENABLE_WEB_PANEL=true \
  -e TZ=CST-8 \
  whyour/qinglong:latest
```

## 三、 登录面板

确保你的设备放行了`5700`端口
用自己的`ip:5700`登录面板

首次登录账号用`admin` 密码用`adminadmin`，提示已初始化密码
去自己映射目录config下找 auth.json，查看里面的 password

``` sh
docker exec -it qinglong cat /ql/config/auth.json
```

把账号密码改自己喜欢的就完事了

## 四、拉取脚本

最新拉取代码点击这里 [🗝](https://github.com/Oreomeow/VIP#-tasks)  
国内vps等加`https://ghproxy.com/`  
> 示例

```sh
ql repo https://ghproxy.com/https://github.com/zooPanda/zoo.git "zoo"
```

<details>
  <summary>曾经的库拉取代码</summary>

在青龙主页添加4个定时任务，定时随便自己喜欢设置，任务代码如下：

```sh
ql repo https://ghproxy.com/https://github.com/chinnkarahoi/jd_scripts.git "jd_|jx_|getJDCookie" "activity|backUp" "^jd[^_]|USER"
```

```sh
ql repo https://ghproxy.com/https://github.com/monk-coder/dust.git "i-chenzhe|normal|member|car" "backup"
```

```sh
ql repo https://ghproxy.com/https://github.com/nianyuguai/longzhuzhu.git "qx"
```

```sh
ql repo https://ghproxy.com/https://github.com/whyour/hundun.git "quanx" "tokens|caiyun|didi|donate|fold|Env"
```

上面4个分别是lxk0301的、藏经阁的、龙猪猪的京豆雨、混沌的京东京喜系列
</details>

## 五、Cookie管理

登陆成功进入Cookie管理页面，右上角新增Cookie(最新版已加Cookie格式验证)
添加成功，可在Cookie列表更新Cookie，删除Cookie

## 六、基本命令

(容器内执行或者新建定时任务时忽略docker exec -it qinglong)

- 更新青龙

``` sh
docker exec -it qinglong ql update
```

- 更新青龙并编译

``` sh
docker exec -it qinglong ql restart
```

- 拉取自定义仓库

``` sh
docker exec -it qinglong ql repo https://ghproxy.com/https://github.com/whyour/hundun.git "quanx" "tokens|caiyun|didi|donate|fold|Env"
```

- 拉取单个脚本

``` sh
docker exec -it qinglong ql raw https://ghproxy.com/https://raw.githubusercontent.com/moposmall/Script/main/Me/jx_cfd.js
```

- 删除7天前的所有日志

``` sh
docker exec -it qinglong ql rmlog 7
```

- 启动bot

``` sh
docker exec -it qinglong ql bot
```

- 导出互助码

``` sh
docker exec -it qinglong ql code
```

- 通知测试

``` sh
docker exec -it qinglong notify test test
```

- 立即执行脚本

``` sh
docker exec -it qinglong task test.js now
```

- 并行执行脚本

``` sh
docker exec -it qinglong task test.js conc
```

## 来源

- 公众号少年歌行pro

> 教程 <https://t.me/shao66>

## 其他教程集合

- 青龙教程合集 （基于Cent OS 7.6）

> <https://www.notion.so/Cent-OS-7-6-1c598629675145988b43a37998a1604a>

- 2.8使用指南等

> <https://www.kejiwanjia.com/notes/2255.html>

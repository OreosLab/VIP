## 简介

本程序仅限青龙面板 2.0 对接使用，添加自助扫码功能。

更多功能如下：


- 扫码添加 / 更新 cookie
- 删除 cookie
- 查看单用户日志


## 说明

本程序已开源，不存在后门等恶意代码。

后端仓库：https://github.com/huayu8/JDC

前端仓库：https://github.com/huayu8/JDC-web

请勿将本程序使用于商业化行为中，否则一切后果自行承担。

由于本人技术有限，不保证程序的可用性以及安全性，由使用本程序造成的一切损失请自行承担。

在使用中发现的 bug 可在此留言，有时间会修复。

## 开始使用

> ⚠ 如果安装了低版本请先移除 JDC 和 config.toml，然后全新安装

### 检查环境

请确保你的环境中已经安装了青龙面板 2.0。

安装 wget 和 unzip

``` sh
//ubuntu
apt install wget unzip
```

```
//centos
yum install wget unzip -y
```

### 单节点部署

如果你只想部署在一台服务器上，推荐前后端部署于一台服务器上。

#### 后端安装

首先 cd 到青龙面板容器的映射目录 (一般为 /root 或根目录)，检查是否存在 ql 或 QL 目录。

``` sh
cd /root
ls -l
```

请按照你的 cpu 架构进行下载

``` sh
//如果你是amd64架构（服务器，PC等）
wget https://github.com/huayu8/JDC/releases/download/2.0.2/linux_amd64.zip && unzip linux_amd64.zip
```
``` sh
//如果你是arm架构（N1，路由器，树莓派等）
wget https://github.com/huayu8/JDC/releases/download/2.0.2/linux_arm.zip && unzip linux_arm.zip
```

##### 失效请看
``` sh
//如果你是amd64架构（服务器，PC等）
wget https://github.com/Oreomeow/JDC/releases/download/2.0.2/linux_amd64.zip && unzip linux_amd64.zip
```
``` sh
//如果你是arm架构（N1，路由器，树莓派等）
wget https://github.com/Oreomeow/JDC/releases/download/2.0.2/linux_arm.zip && unzip linux_arm.zip
```

其他架构或系统请自行编译

``` sh
chmod 777 JDC
./JDC
```

第一次运行，自动生成配置文件并且程序会自动退出。

> 🔵 如果你的容器映射文件夹为 ql，请手动修改 config.toml 中的 path 项为 ql (不用加后缀)！

程序设置请自行修改 config.toml 文件。

然后执行下面步骤

``` sh
nohup ./JDC &
```

开始后台运行程序。程序默认端口为 5701。打开 `http://ip:5701/info` 看到 “JDC is Already！” 即说明安装成功！

如果无法打开请检查端口是否放行！

#### 前端部署

> 🔵 程序现已支持反向代理，直接使用 nginx 反代目标端口即可！

单节点安装时前端推荐直接部署于 JDC 自带的 http 服务器中。

首先 cd 到 JDC 同级目录下的 public 文件夹中（如果没有请新建），并下载解压前端文件

``` sh
cd public

wget https://github.com/huayu8/JDC-web/releases/download/1.0.0/dist.zip && unzip dist.zip
```

然后直接访问 IP + 端口即可看到面板。

如需前后端分离部署请参考多节点安装 - 前端部署章节

### 多节点部署

程序支持同一个面板对接多个后端节点，此方式部署程序推荐前后端分离部署。

#### 后端安装
请参考单节点部署 - 后端安装章节

#### 前端部署

`推荐前后端分离部署，可使用反代 / CDN 提高可用性`

多节点前端部署需要拉取前端仓库并修改 api 编译。

> 以下步骤在你的电脑上操作（请确保你的电脑安装了 git/nodejs/npm）

拉取前端仓库并进入

``` sh
git clone https://github.com/huayu8/JDC-web.git
```

拉取完成后请进入 JDC-web 文件夹，然后在根目录找到.env.production 文件，修改其中的内容。

其中，name 为节点名称，url 为 `http://ip + 端口`，此处 ip 为后端节点的公网 IP，端口为 JDC 运行的端口，可添加多个节点

例如:

``` sh
NODE_ENV=development
VUE_APP_API_URL=[{"name":"京东节点1","url":"http://127.0.0.1:5701"},{"name":"京东节点2","url":"http://127.0.0.1:5702"}]
```

💔`此处请确保节点 JSON 的格式正确，否则会出现未知错误！`

开始编译

``` sh
npm install

npm run build
```

编译完成后，将 dist 目录中的文件打包，上传至任意 http 服务器即可。（你也可以上传到任意后端节点 JDC 同级目录下的 public 文件夹内，因为 JDC 本身自带 http 服务器）

访问页面即可！

### 更新教程

如果你已经安装了旧版程序，请按以下步骤删除原程序，再按照上述教程进行部署。

首先 kill 掉原来的程序。

``` sh
//查看原程序PID,第一行第二列为程序的PID
ps -ajx|grep JDC
```
``` sh
//结束程序（*****改为你的PID）
kill -9 *****
```

然后删除原来的程序和 config.toml 文件

``` sh
rm -rf JDC config.toml
```
## 界面展示
<div align="center"><img src="https://github.com/Oreomeow/VIP/blob/main/Icons/qinglong/JDC/JDC-1.png"></div>  
<div align="center"><img src="https://github.com/Oreomeow/VIP/blob/main/Icons/qinglong/JDC/JDC-2.png"></div>  
<div align="center"><img src="https://github.com/Oreomeow/VIP/blob/main/Icons/qinglong/JDC/JDC-3.png"></div>    
<div align="center"><img src="https://github.com/Oreomeow/VIP/blob/main/Icons/qinglong/JDC/JDC-4.png"></div>

> 本文作者： HuaYu @一花一世界  
> 本文链接： https://ihuayu8.cn/ql-get-cookie.html  
> 版权声明： 本站所有文章除特别声明外，均采用 (CC)BY-NC-SA 许可协议。转载请注明出处！


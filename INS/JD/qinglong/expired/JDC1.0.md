# 青龙面板扫码获取 Cookie

> ⛔是时候说再见了！有缘江湖再见！

> 2021.05.30 程序不再提供下载与安装服务！

> 2021.05.26 已更新并修复了一些小 BUG

- 修复了 cookie 删除失败的 bug
- 增加是否允许新增账号的设置项
- 修复日志失效的 BUG
- 现在可以在 config.toml 中设置日志的文件名称了，更多配置项请自行查看

更新教程请看下方。

## 简介
本程序仅限青龙面板 2.0 对接使用，添加自助扫码功能。  
更多功能如下：
- 扫码添加 / 更新 cookie
- 删除 cookie
- 查看单用户日志

## 说明
本程序已开源，不存在后门等恶意代码。

https://github.com/huayu8/JDC  

请勿将本程序使用于商业化行为中，否则一切后果自行承担。

由于本人技术有限，不保证程序的可用性以及安全性，由使用本程序造成的一切损失请自行承担。

在使用中发现的 bug 可在此留言，有时间会修复。

## 开始使用
### 检查环境
请确保你的环境中已经安装了青龙面板 2.0。

首先 cd 到青龙面板容器的映射目录。(一般为 /root)

``` sh
cd /root
ls -l
```

如果发现有 QL 文件夹，即说明目录正确。

### 下载程序
请先安装 wget 和 unzip

``` sh
//ubuntu
apt install wget unzip
```
``` sh
//centos
yum install wget unzip -y
```

请按照你的 cpu 架构进行下载

``` sh
//如果你是amd64架构（服务器，PC等）
wget https://github.com/huayu8/JDC/releases/download/1.0.2/linux_amd64.zip && unzip linux_amd64.zip
```
``` sh
//如果你是arm架构（N1，路由器，树莓派等）
wget https://github.com/huayu8/JDC/releases/download/1.0.2/linux_arm.zip && unzip linux_arm.zip
```

其他架构或系统请自行编译

### 开始使用

``` sh
chmod 777 JDC
./JDC
```

第一次运行，自动生成配置文件并且程序会自动退出。如果你没有修改过青龙面板的端口，可直接执行下一步。

如果不为默认端口，请自行修改 `config.toml` 文件

然后执行下面步骤

``` sh
nohup ./JDC &
```

开始后台运行程序。程序默认端口为 `5701`。打开 http://ip:5701 即可看到面板

如果无法打开请检查端口是否放行。

### 更新教程
如果你已经安装了旧版程序更新时如下操作。

首先 kill 掉原来的程序。

``` sh
//查看原程序PID,第一行第二列为程序的PID
ps -ajx|grep JDC
//结束程序（*****改为你的PID）
kill -9 *****
```

然后删除原来的程序和 config.toml 文件

``` sh
rm -rf JDC config.toml
```

下载新程序并执行一次

``` sh
//如果你是amd64架构（服务器，PC等）
wget https://github.com/huayu8/JDC/releases/download/1.0.2/linux_amd64.zip && unzip linux_amd64.zip
```
``` sh
//如果你是arm架构（N1，路由器，树莓派等）
wget https://github.com/huayu8/JDC/releases/download/1.0.2/linux_arm.zip && unzip linux_arm.zip
```
``` sh
chmod 777 JDC

./JDC
```

生成新的配置文件后，如有需要请自行更改

运行新版本程序

``` sh
nohup ./JDC &
```

## 界面展示
![cookie-get][cookie-get]  
![2][2]

> 本文作者： HuaYu @一花一世界  
> 本文链接： https://ihuayu8.cn/ql-get-cookie.html  
> 版权声明： 本站所有文章除特别声明外，均采用 (CC)BY-NC-SA 许可协议。转载请注明出处！


--------------------
[cookie-get]:https://github.com/Oreomeow/VIP/blob/main/Icons/qinglong/JDC/cookie-get.png
[2]:https://github.com/Oreomeow/VIP/blob/main/Icons/qinglong/JDC/2.png

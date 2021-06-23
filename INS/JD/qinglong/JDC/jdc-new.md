# 群晖Docker青龙面板搭建花语JDC扫码及互助使用方法 6.16更新花语2.0.3版本

背景：因大佬陆续删库，目前青龙面板可能是最好的搭建平台了。关于扫码面板和互助的使用呼声较高，积极响应大家号召，赶出来一篇稿子，希望对大家有帮助。

<p align="center">PS：文章有点长，搞了目录树，见右边，方便大家查看。</p>

## 花语面板搭建教程（2.0.2版本拉到最后）


### 一、下载编译过的花语面板JDC压缩包（傻瓜式安装），解压后选择合适自己架构的JDC文件。

由网友编译过的: https://pan.baidu.com/s/1HWWngL5-WxeTmg5XyNDsYg 提取码: iufs

> 原参考教程：https://blog.mrjiang.top/archives/7/

> ⚠注意：默认的“JDC”是AMD64架构的，适用服务器，PC等；<br>“JDC-ARM”是ARM架构的，适用于斐讯N1、路由器等。<br>请根据自己的设备选择，如适用ARM架构，请删除JDC文件，并将JDC-ARM重命名为JDC。

再提供一个源码文件备份：https://pan.baidu.com/s/1Ic_-sVw–6rcJtleCgyjXA 提取码: phym


### 二、复制文件夹内的文件，到青龙本地映射的文件夹内。

> ⚠注意：不是整个文件夹复制，而是文件夹内的文件。

![我的目录][我的目录]


### 三、通过ssh连接群晖，推荐工具finalshell（不知道方法的自行百度）

[windows版下载地址](http://www.hostbuf.com/downloads/finalshell_install.exe)

[macos版下载地址](http://www.hostbuf.com/downloads/finalshell_install.pkg)


### 四、依次通过以下命令进行安装

1、进入青龙文件夹路径

``` sh
sudo -i（获取root权限）
cd /volume1/docker/QL（进入青龙文件夹路径）
```

> 🔵命令说明：/volume1/docker/QL是指你的文件夹路径，每个人的不一样，自行查询并更改命令。

2、分配权限生成配置文件并进行初始化

```
chmod 777 JDC
./JDC
```

3、修改配置文件，主要是将/ql修改成自己的文件路径

```
vi config.toml
```

1）按字母“i”进入编辑模式，将光标移动到“/ql”处，将“/ql”修该为“自己的实际路径”。

2）修改好后，按ESC键退出编辑模式，再输入”:wq”（保存并退出）。

![conf][conf]

3）运行花语扫码程序

```
nohup ./JDC
```


### 五、Bingo，快去登录看看是否成功了吧！访问网址：http://ip:5701

![控制面板][控制面板]

### 六、修改HTML，但是不成功怎么办？（高手用，小白忽略，我也不会，只是收录备用）
因为作者把静态资源打包后，以通过模块的形式进行导入。请删除掉该导入，将静态资源放在同JDC同目录或者public文件夹内进行读取。

具体步骤：

1）编辑main.go并删除`_ "getJDCookie/packed"`

![main.go][main.go]

2）将修改好的静态文件放入JDC所在文件的public目录里或根目录

![public][public]

3）GO编译

打开CMD，使用cd命令切换到源文件根目录

``` go
//编译前修改运行环境
//GOARCH指的是目标处理器的架构，支持一下处理器架构 arm arm64 386 amd64 ppc64 ppc64le mips64 mips64le s390x
set GOARCH=amd64
//GOOS指的是目标操作系统，支持以下操作系统 darwin freebsd linux windows android dragonfly netbsd openbsd plan9 solaris
set GOOS=linux
//Go语言 编译命令
go build -o JDC
```

## 互助使用教程

### 一、添加下面的自定义仓库，并手动运行一次进行添加脚本。

```
ql repo https://github.com/chinnkarahoi/jd_scripts.git "jd_|jx_|getJDCookie" "activity|backUp" "^jd[^_]|USER"
```

### 二、打开青龙面板，选择配置文件，自动互助设置为true，修改name_js参数并保存。

![help][help]

<center>特别说明：互助模式按需选择。</center>

```
name_js=(
chinnkarahoi_jd_scripts_jd_fruit
chinnkarahoi_jd_scripts_jd_pet
chinnkarahoi_jd_scripts_jd_plantBean
chinnkarahoi_jd_scripts_jd_dreamFactory
chinnkarahoi_jd_scripts_jd_jdfactory
chinnkarahoi_jd_scripts_jd_jdzz
chinnkarahoi_jd_scripts_jd_crazy_joy
chinnkarahoi_jd_scripts_jd_jxnc
chinnkarahoi_jd_scripts_jd_bookshop
chinnkarahoi_jd_scripts_jd_cash
chinnkarahoi_jd_scripts_jd_sgmh
chinnkarahoi_jd_scripts_jd_cfd
chinnkarahoi_jd_scripts_jd_health
```

### 三、返回定时任务界面，搜索互助码，找到“ql code”并运行。

![qlcode][qlcode]

### 四、这样就设置成功了，再去运行相关脚本看看是否已经自动互助了。


## 更新花语面板搭建教程（2.0.3版本）

今天发现大佬有开放库了，赶紧把最新版本的文件下了，顺便更新了面板。如果想体验新版本的同学，可以折腾一下。

温馨提示，大佬因为开源，有的人自己改了，可以拿到大家的ck，建议使用源码，不要随便网上下载编译后的。

大佬又删库了，附百度云备份。大佬们最近都好佛啊。说来就来，就走就走，不带走一片云彩。

2.0.2版本 百度云：https://pan.baidu.com/s/1VuX7Th3pwJMRG0mzYCi5uw 提取码: vc83

2.0.3版本 百度云: https://pan.baidu.com/s/1snjp–CQN51r3L_aX6Z-Jw 提取码: 8sd4

废话不多说，上教程。

### 一、如果你已经安装了旧版本，需要先停用卸载旧版本。全新安装跳到第二步。

``` sh
ps -ajx|grep JDC
##查看原程序PID,第一行第二列为程序的PID
kill -9 *****
##结束程序（*****改为你的PID）
##结束后无任何提示，不放心再输入一下，会提示无此进程。
rm -rf JDC config.toml
##删除配置文件和JDC主程序
##不放心进入安装目录检查一下，顺便把public文件夹也清空。
```

![reinstall][reinstall]

### 二、下载需要的JDC后端和前端文件（尽量早点下载，大佬心情不好就删库了，哈哈）

后端压缩包地址：https://github.com/huayu8/JDC/releases/tag/2.0.2

前端压缩包地址：https://github.com/huayu8/JDC-web/releases/tag/1.0.0

> ⚠注意后端文件：AMD64架构的，适用服务器，PC等；ARM架构的，适用于斐讯N1、路由器等。<br>请根据自己的设备选择。

### 三、解压后端压缩包文件“JDC”，到青龙本地映射的文件夹内。（从这里开始重复旧版本第二步开始的步骤，不重复配图了）

### 四、ssh连接群晖，通过命令安装后端

1）通过root权限进入青龙文件夹

``` sh
sudo -i（获取root权限）
cd /volume1/docker/QL（进入青龙文件夹路径，根据自己的路径调整）
```

2）分配权限生成配置文件并进行初始化

``` sh
chmod 777 JDC
./JDC
```

3）修改配置文件，主要是将/ql修改成自己的文件路径

```sh
vi config.toml
```

1）按字母“i”进入编辑模式，将光标移动到“/ql”处，将“/ql”修该为“自己的实际路径”。

> ⚠这里跟旧版不一样，只要到文件夹即可，不需要“/config/auth.json”

![config.toml][config.toml]

2）修改好后，按ESC键退出编辑模式，再输入”:wq”（保存并退出）。

3）再次输入命令运行即可。

``` sh
nohup ./JDC &
```

五、开始前端部署
将下载的前端部署文件，解压到public文件夹内。

> ⚠不要整个文件夹放入，而是将dist里面的文件放入public。

六、Bingo，快去体验新版本的扫码吧，访问网址：http://ip:5701

> 🚫如果进入不了，尝试root身份cd到青龙文件夹，尝试再次输入命令启动一次。如果还是不行，排查原因，卷土重来。我也搞了3次才成功，总有一些被你忽略的错误。比如我搞错过路径，没用root身份等。总之多试试吧。

``` sh
./JDC
或
nohup ./JDC &
```

## 原文链接
> https://www.kejiwanjia.com/zheteng/1483.html#i-4


[我的目录]:https://github.com/Oreomeow/VIP/blob/main/Icons/qinglong/JDC/%E6%88%91%E7%9A%84%E7%9B%AE%E5%BD%95.png
[conf]:https://github.com/Oreomeow/VIP/blob/main/Icons/qinglong/JDC/conf.png
[控制面板]:https://github.com/Oreomeow/VIP/blob/main/Icons/qinglong/JDC/%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%9D%BF.png
[main.go]:https://github.com/Oreomeow/VIP/blob/main/Icons/qinglong/JDC/main.go.png
[public]:https://github.com/Oreomeow/VIP/blob/main/Icons/qinglong/JDC/public.png
[help]:https://github.com/Oreomeow/VIP/blob/main/Icons/qinglong/JDC/help.png
[qlcode]:https://github.com/Oreomeow/VIP/blob/main/Icons/qinglong/JDC/qlcode.png
[reinstall]:https://github.com/Oreomeow/VIP/blob/main/Icons/qinglong/JDC/reinstall.png
[conf.toml]:https://github.com/Oreomeow/VIP/blob/main/Icons/qinglong/JDC/conf.toml.png

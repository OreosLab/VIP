# 使用docker来部署nevinee/jd的jd签到脚本

> 写这个教程是为了之后重装系统时候，可以用来参考一下，以防自己忘了。现在网上还是挺少这个详细的教程的。本教程仅供交流参考，如果使用本教程搭建服务之后出现封号什么的，不要来找我。是你自己的责任。

下面开始

- nevinee/jd的脚本发布页是：https://hub.docker.com/r/nevinee/jd 这个脚本的原作者是lxk0301大佬，因为某些人为了自己的利益导致这位大佬的仓库被迫转为私有仓库。而nevinee是少数经lxk0301大佬授权可以发布在自己仓库的大佬之一。本教程主要还是以lxk0301大佬的脚本为例，来介绍jd签到脚本的安装步骤，以及安装控制面板，因为lxk0301大佬自己的脚本是不带控制面板的。我安装时候也是网上找了好久也没找到教程，最后是群里一位大佬帮忙解决的。
- 这里演示用openwrt系统内的docker为例，其他系统应该都差不多。
- 如果你的openwrt没有安装的话，自行百度安装

## 1. 确认你系统的docker已经打开了

![Docker CE][Docker CE]

## 2. 使用ssh工具连接你安装docker的机器

![ssh][ssh]

## 3. 鼠标右键复制以下全部命令，然后在命令框内鼠标右键点一下黏贴命令

``` sh
 docker run -dit \
-v /root/jd/config:/jd/config \
-v /root/jd/jd/log:/jd/log \
-v /root/jd/own:/jd/own \
-v /root/jd/scripts:/jd/scripts \
-e ENABLE_HANGUP=true \
-e ENABLE_TG_BOT=true \
-e ENABLE_WEB_PANEL=true \
-p 5678:5678 \
--name jd \
--hostname jd \
--restart always \
nevinee/jd:v4-bot
```

![pull][pull]

等待它镜像拉去完成，如果提示错误多试几次，还是不行就自行百度吧!

![ps][ps]

输入`docker ps -a`可以查看当前已经部署的容器，可以看到jd签到脚本已经安装好了。

## 4. 然后我们用winSCP这个软件登入到openwrt里，这个软件是用来给服务器等机器来传输管理文件用的，这里用它来传输一个脚本，用来安装控制面板

![WinSCP][WinSCP]

如果你没有用过这个软件的话安装好打开应该是只有一个新建站点。你只要点击新建站点，文件协议选择SCP，然后输入你的openwrt系统ssh的用户名和密码登录就好了

![jd][jd]

可以看到openwrt里面有一个叫jd的文件夹，这个就是我们jd签到脚本的配置文件。

## 5. 然后我们把脚本文件上传到有root这个文件夹（一般默认在root这个文件夹）

![root][root]

## 6. 然后我们执行以下命令

``` sh
docker cp /root/install-panel.sh jd:/jd
```

这条命令的意思是把install-panel.sh这个文件复制到容器内部。如果你的文件不是在这个地方，那你就自己百度Linux复制文件命令怎么用，命令前面加docker。

![cp][cp]

## 7. 接着我们再执行以下命令，进入容器内部。

``` sh
docker exec -it jd /bin/bash
```

![it][it]

## 8. 然后我们输入ls命令来查看我们有没有把这个文件传到容器内部

![ls][ls]

## 9. 接着我们输入下面命令来远行这个脚本安装控制面板

``` sh
bash install-panel.sh
```

当显示以下画面时候就是表示面板安装成功。用户名是：`admin` 密码是：`adminadmin`

在你的浏览器里输入：你路由器或者服务器ip加端口5678

![done][done]  
![mb][mb]

## 10. 浏览器打开输入用户名和密码后就可以登入了，这个就是京东脚本的控制面板了，然后跟着注释去编辑内容就可以了。主要需要填的是Cookie和通知，Cookie可以通过点击扫码获取Cookie。用你的京东app扫码，它会自动替换，如果没有自动替换就自己手动填到Cookie里就可以了。假设你有多个京东账户要签到话，就在Cookie2下面加上Cookie3=""、Cookie=""等等，再把扫码获取到的Cookie信息填到引号内。

![config][config]  
![cookie][cookie]

## 11. 然后我们来配置通知，因为这位大佬的脚本更多使用TG机器人来通知，而因为我们国内政策原因TG使用不方便。所以可以使用pushplus来通知，它会把信息推送到你微信pushplus公众号里。

官网：http://www.pushplus.plus/

只要用微信扫码关注，然后点一对一推送就可以看到你的token，这个是我们用来推送通知的

![pushplus][pushplus]  
![token][token]

## 12. 然后 在config.sh里第二区域加上一行，这个就是表示用pushplus来推送。把你在pushplus获取到的token填到引号内。然后点击保存，这样你的jd签到脚本基本就部署完了。

``` sh
export PUSH_PLUS_TOKEN=""
```

![export][export]

## 13. 我们可以点击手动执行来查看我们通知部署是不是成功了，如下图操作输入

`jd_bean_change.js`

可以看到成功推送到手机微信公众号上。

![jtask][jtask]  
![log][log]  
![push][push]



## 结语

> 这就是这个教程的全部内容了，已经讲的很详细了，再不会的话那就只能付费用那些二道贩子的一键脚本了。如果你要玩那些小游戏的话，要自己去京东里面挨个把小游戏打开一下。感谢那些大佬的辛苦付出，我们用就用不要到处宣传。毕竟我们这么做也是在薅京东羊毛，万一把京东薅疼了把这个给关了。大家都没得玩了，所以珍惜把。最后，config.sh建议用我给的，通知方式多一些。直接把下载的文件拖到jd文件夹里的config文件内替换，当然在在线编辑工具里面全选替换也是可以的，然后执行重启容器命令，等重启完成去浏览器就可以看到看更新了的内容。

``` sh
docker restart jd
```

- 文件链接: https://pan.baidu.com/s/1XObI9m_CdhGdAJUFMZ-HpA 提取码: bxpv
- 文件链接:https://drive.google.com/file/d/18enFAbS6KLSPlPWgnr1udw48KeMOCTHx/view?usp=sharing
- 文件链接:https://wwr.lanzous.com/iU8MNopdqtc 密码:1m32

(我就不信全部完蛋）

![config.sh][config.sh]  
![replace][replace]

## 原文链接
> https://www.yuque.com/duya233/lx4vqg/fpegc5


[Docker CE]:https://github.com/Oreomeow/VIP/blob/main/Icons/nevinee/Docker%20CE.png
[ssh]:https://github.com/Oreomeow/VIP/blob/main/Icons/nevinee/ssh.png
[pull]:https://github.com/Oreomeow/VIP/blob/main/Icons/nevinee/pull.png
[ps]:https://github.com/Oreomeow/VIP/blob/main/Icons/nevinee/ps.png
[WinSCP]:https://github.com/Oreomeow/VIP/blob/main/Icons/nevinee/WinSCP.png
[jd]:https://github.com/Oreomeow/VIP/blob/main/Icons/nevinee/jd.png
[root]:https://github.com/Oreomeow/VIP/blob/main/Icons/nevinee/root.png
[cp]:https://github.com/Oreomeow/VIP/blob/main/Icons/nevinee/cp.png
[it]:https://github.com/Oreomeow/VIP/blob/main/Icons/nevinee/it.png
[ls]:https://github.com/Oreomeow/VIP/blob/main/Icons/nevinee/ls.png
[done]:https://github.com/Oreomeow/VIP/blob/main/Icons/nevinee/done.png
[mb]:https://github.com/Oreomeow/VIP/blob/main/Icons/nevinee/mb.png
[config]:https://github.com/Oreomeow/VIP/blob/main/Icons/nevinee/config.png
[cookie]:https://github.com/Oreomeow/VIP/blob/main/Icons/nevinee/cookie.png
[pushplus]:https://github.com/Oreomeow/VIP/blob/main/Icons/nevinee/pushplus.png
[token]:https://github.com/Oreomeow/VIP/blob/main/Icons/nevinee/token.png
[export]:https://github.com/Oreomeow/VIP/blob/main/Icons/nevinee/export.png
[jtask]:https://github.com/Oreomeow/VIP/blob/main/Icons/nevinee/jtask.png
[log]:https://github.com/Oreomeow/VIP/blob/main/Icons/nevinee/log.png
[push]:https://github.com/Oreomeow/VIP/blob/main/Icons/nevinee/push.png
[config.sh]:https://github.com/Oreomeow/VIP/blob/main/Icons/nevinee/config.sh.png
[replace]:https://github.com/Oreomeow/VIP/blob/main/Icons/nevinee/replace.png

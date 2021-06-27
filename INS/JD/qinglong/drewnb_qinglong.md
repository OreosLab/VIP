更新内容 ：新增JDC启动的环境变量 ENABLE_WEB_JDC 以解决可能会出现的BUG（需要JDC自启动的请添加）

仅限服务器、pc及部分arm等设备使用

版本介绍：

2.2-jdc 为锁定版，以更改为本人源码（源码更改自limoe大佬），无bot，jdc随容器启动

2.2-jdc-bot 为锁定版，以更改为本人源码（源码更改自limoe大佬），有bot，jdc随容器启动

jdc为2.2锁定纯净版，无JDC,无BOT（注意要将ENABLE_WEB_JDC 环境变量设置为false）

``` sh
docker run -dit
-v $PWD/ql/config:/ql/config
-v $PWD/ql/log:/ql/log
-v $PWD/ql/scripts:/ql/scripts
-p 5700:5700
-p 5701:5701
-e ENABLE_HANGUP=false
-e ENABLE_WEB_PANEL=true
-e ENABLE_WEB_JDC=true
--name qinglong
--hostname qinglong
--restart always
drewnb/qinglong:2.2-jdc-bot
```

青龙bot

重启后请进入青龙面板-配置文件-设置AutoStartBot=”true”，这样每次容器重启，bot也会自动重启。

青龙IP： 容器IP:5700

JDCIP： 容器IP:5701

多容器部署：

-p 5700:5700 \ XXXX:5700

-p 5701:5701 \XXXX:5701

本人不接受任何打赏，同时感谢whyour、花语以及limoe大佬的无私奉献（排名不分先后，在本人心中同等重要），如果认同本容器，烦请多多关注以上大佬，没有他们的无私奉献，也就没有今天的百花齐放，最后警告，不要让本容器出现在任何公众平台！（我很低调，不希望有人记得我）

## DockerHub
> https://registry.hub.docker.com/r/drewnb/qinglong

- 仅限服务器、pc等设备使用

``` sh
cd /opt
```

``` sh
docker run -dit
-v /opt/ql/config:/ql/config
-v /opt/ql/log:/ql/log
-v /opt/ql/scripts:/ql/scripts
-p 5700:5700
-p 5701:5701
-e ENABLE_HANGUP=false
-e ENABLE_WEB_PANEL=true
--name qinglong
--hostname qinglong
--restart always
drewnb/qinglong:2.2-jdc
```

## 1、进入容器。

``` sh
docker exec -it qinglong bash # 此处为容器名
```

## 2、进入jdc文件夹

```sh
cd jdc/ (2.2-jdc不用再进jdc目录，直接在/ql目录下）
```

## 3、执行：

``` sh
nohup ./JDC >/dev/null 2>&1 &
```

或

```
pm2 start JDC
```

青龙IP 容器IP：5700

jdcIP 容器IP：5701

### 多容器部署：

-p 5700:5700 \ XXXX:5700

-p 5701:5701 \XXXX:5701

## DockerHub
> https://registry.hub.docker.com/r/drewnb/qinglong

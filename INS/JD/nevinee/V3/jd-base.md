## 多谢

本仓库部分shell脚本及其配置参考自[nevinee](https://github.com/nevinee)大佬, [https://github.com/nevinee/jd_shell](https://github.com/nevinee/jd_shell), 感谢👍👍👍

## 免责声明

1. 此仓储脚本仅用于学习研究，不保证其合法性、准确性、有效性，请根据情况自行判断，本人对此不承担任何保证责任。

2. 由于此仓储脚本仅用于学习研究，您必须在下载后 24 小时内将所有内容从您的计算机或手机或任何存储设备中完全删除，若违反规定引起任何事件本人对此均不负责。

3. 请勿将此仓储脚本用于任何商业或非法目的，若违反规定请自行对此负责。

4. 此仓储脚本涉及应用与本人无关，本人对因此引起的任何隐私泄漏或其他后果不承担任何责任。

5. 本人对任何脚本引发的问题概不负责，包括但不限于由脚本错误引起的任何损失和损害。

6. 如果任何单位或个人认为此仓储脚本可能涉嫌侵犯其权利，应及时通知并提供身份证明，所有权证明，我们将在收到认证文件确认后删除此仓储脚本。

7. 所有直接或间接使用、查看此仓储脚本的人均应该仔细阅读此声明。本人保留随时更改或补充此声明的权利。一旦您使用或复制了此仓储脚本，即视为您已接受此免责声明。

## 方法
 ``` sh
 docker run -dit \
	-v $PWD/jd/config:/jd/config \
	-v $PWD/jd/log:/jd/log \
	-p 5678:5678 \
	-e ENABLE_HANGUP=true \
	-e ENABLE_WEB_PANEL=true \
	--name jd \
	--hostname jd \
	--restart always \
	noobx/jd:gitee
```
如需指定目录，请把$PWD更改为指定目录即可，不然则为当前目录!!
执行上面命令之后建议执行docker logs -f jd查看安装进度，直到出现Welcome to Node.js v1x.x.0.代表成功！
如需映射脚本出来直接在上面加一行!：
``` sh
-v $PWD/jd/scripts:/jd/scripts \
```

node基础镜像
```
noobx/jd:gitee
```
集成python与node镜像
```
noobx/jd:py
```
# 命令↓
1. 手动 git pull 更新脚本
``` sh
docker exec -it jd bash git_pull
```
2. 手动删除指定时间以前的旧日志
``` sh
docker exec -it jd bash rm_log
 ```
3. 手动导出所有互助码
``` sh
docker exec -it jd bash export_sharecodes
```
4. 手动启动挂机程序（**容器会在启动时立即启动挂机程序，所以你想重启挂机程序，你也可以重启容器，而不采用下面的方法。**）
``` sh
docker exec -it jd bash jd hangup
```
5. 手动执行薅羊毛脚本，用法如下(其中`-it`后面的`jd`为容器名，`bash`后面的`jd`为命令名，`xxx`为lxk0301大佬的脚本名称)，不支持直接以`node xxx.js`命令运行：
``` sh 
docker exec -it jd bash jd xxx      # 如果设置了随机延迟并且当时时间不在0-2、30-31、59分内，将随机延迟一定秒数
docker exec -it jd bash jd xxx now  # 无论是否设置了随机延迟，均立即运行
```
6. Copy自定义脚本到容器目录
``` sh
docker cp /宿主机上脚本存放路径/test.js jd:/jd/scripts
```
7. 查看创建日志
```shell
docker logs -f jd
```
8. 重置WEB面板密码
``` sh
docker exec -it jd bash jd resetpwd
```
9. 查看挂机脚本日志
``` sh
docker exec -it jd pm2 monit`或`docker exec -it jd pm2 logs
```
10. 重启容器
``` sh
docker restart jd
```
11. 如何自动更新镜像！
``` sh
docker run -d \
    --name watchtower \
    --restart always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    containrrr/watchtower \
    --cleanup
```

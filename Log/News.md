# News
## 06.28 18:05
- JDC fix remote scan 安装方法

终端输入
``` sh
yum install wget unzip -y
```
``` sh
cd /root 
```
``` sh
ls -l 
```

AMD64 终端输入
``` sh
wget https://github.com/Zy143L/jdc/releases/download/2.0/JDC
```

arm64 终端输入
``` sh
wget https://github.com/Zy143L/jdc/releases/download/2.0/JDC_arm64
```

终端输入
``` sh
chmod 777 JDC 

./JDC 
```

修改 `config.toml` 中的 `path` 项为 `ql`

AMD64 终端输入
``` sh
nohup ./JDC 1>/dev/null 2>&1 & #AMD64
```

arm64 终端输入 
``` sh
nohup ./JDC_arm64 1>/dev/null 2>&1 & #ARM64
```

打开 `http://ip:5701/info` 看到 “JDC is Already！” 即说明安装成功！

前端安装 终端输入
``` sh
cd public 
```
```
wget http://nm66.top/dist.zip && unzip dist.zip
```

然后直接访问 IP + 5701 即可看到面板。

如果要重新安装 先终端输入
``` sh
netstat -lnp|grep 5701
```
比如输出了 tcp 0 0 0.0.0.0:5701 0.0.0.0:* LISTEN 28937/java

然后执行 kill 关闭该应用程序 数字就是后面的 28937

终端输入

``` sh
kill -9 28937
```

JDC修复编译来着网络资源

宝塔需要在安全组打开 5701 端口

具体需要自测

- 神秘大佬
``` sh
docker pull lxk0301/jd_cookie
```
``` sh
docker run -d –name jd_cookie -p 6789:6789 -e QYWX_KEY={QYWX_KEY} -e QYWX_AM={QYWX_AM} -e UPDATE_API={UPDATE_API} echowxsy/jd_cookie
```
## 06.28 17:25
- 青龙面板小工具 适用于 2.2 面板
    - 修复远程扫码问题 支持 AMD64 和 ARM64 架构 *by Zy143L*  
    https://github.com/Zy143L/jdc
    - 配套前端地址  
    https://github.com/Zy143L/JDC_WEB
    - 配套青龙 2.2-066 不升级版本  
    https://hub.docker.com/r/limoe/qinglong
## 06.28 01:30
- 青龙面板无法打开解决命令
``` sh
docker exec -it qinglong nginx -c /etc/nginx/nginx.conf
```
- A1/shuye/V3/V4 京东扫码恢复及网页扫码获取
> https://shimo.im/docs/RkkWrrQVpxk3TTjR
## 06.27 19:44
- qinglong 2.8 一键添加内部互助功能  
    - 容器内执行 或 docker 宿主机执行
    - 默认仓库为`JDHelloWorld`，使用其他仓库需自行修改
``` sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/liuqitoday/qinglong-auto-sharecodes/master/one-key.sh)"
```
``` sh
docker exec -it qinglong bash -c "$(curl -fsSL https://raw.githubusercontent.com/liuqitoday/qinglong-auto-sharecodes/master/one-key.sh)"
```

## 06.26 21:30
- 口袋书店入口  
京东 APP：`首页`-（中间第二页）`京东图书`-（右上角）`签`-（页面中间）每日参加活动

## 06.26 14:50
- 京东查黑号最新办法  
> https://vip.m.jd.com/scoreDetail/current
  
电脑或者手机浏览器复制打开网址，从里面查找`creditLevel`，最高 11 级，低于 8 的抢啥都很难，低于 5 的就不要抢购了。需要登陆过京东账户。

## 06.26 14:00
- `panghu999`宠汪汪报错原因：据说国外 vps 才会报这个错误
```
❗️宠汪汪, 错误!
evalmachine.<anonymous>:1
<html>
^

SyntaxError: Unexpected token '<'
    at new Script (vm.js:101:7)
    at createScript (vm.js:262:10)
    at Object.runInContext (vm.js:293:10)
    at IncomingMessage.<anonymous> (/ql/scripts/panghu999_jd_scripts_jd_joy.js:2387:28)
    at IncomingMessage.emit (events.js:388:22)
    at endReadableNT (internal/streams/readable.js:1336:12)
    at processTicksAndRejections (internal/process/task_queues.js:82:21)
```
- `JDHelloWorld`拉取仓库命令如下，cron 设为`55 * * * *`（晚于`panghu999`的`50 * * * *`)
``` sh
ql repo https://github.com/JDHelloWorld/jd_scripts "jd_|jx_|getJDCookie" "activity|backUp|jd_delCoupon" "^jd[^_]|USER"
```
```
55 * * * *
```
- 宠汪汪同样使用`JDHelloWorld`的仓库，禁用其他的只跑`宠汪汪二代目`即可，cron 改为`15 0-23/2 * * *`
- 宠汪汪兑换使用`JDHelloWorld`的仓库，禁用其他的只跑`宠汪汪兑换二代目`即可，cron 改为`0 0-16/8 * * *`或 ? `57-59/1 59 7-23/8 * * *`（自行测试） 
- `JDHelloWorld`宠汪汪验证解决命令
``` sh
docker exec -it qinglong pnpm i png-js -S
```
- `panghu999`宠汪汪验证解决命令
``` sh
docker exec -it qinglong /bin/sh
```
``` sh
apk add --no-cache build-base g++ cairo-dev pango-dev giflib-dev
```
``` sh
cd scripts
```
``` sh
npm install canvas --build-from-source
```
``` sh
exit
```

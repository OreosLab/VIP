# News
## 06.26 21:30
- 口袋书店入口
京东APP`首页`-(中间第二页）`京东图书`-（右上角）`签`-（页面中间）每日参加活动
## 06.26 14:50
- 京东查黑号最新办法  
https://vip.m.jd.com/scoreDetail/current  
电脑或者手机浏览器复制打开网址，从里面查找`creditLevel`，最高11级，低于8的抢啥都很难，低于5的就不要抢购了。需要登陆过京东账户。

## 06.26 14:00
- `panghu999`宠汪汪报错原因：据说国外vps才会报这个错误
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
- 宠汪汪兑换使用`JDHelloWorld`的仓库，禁用其他的只跑`宠汪汪兑换二代目`即可，cron 改为`0 0-16/8 * * *`或`0-3 0 0-16/8 * * *`
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

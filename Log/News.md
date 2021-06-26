# News
## 06.26 13:20
- `JDHelloWorld`拉取仓库命令如下，cron 设为`55 * * * *`（晚于`panghu999`的`50 * * * *`)
``` sh
ql repo https://github.com/JDHelloWorld/jd_scripts "jd_|jx_|getJDCookie" "activity|backUp|jd_delCoupon" "^jd[^_]|USER"
```
```
55 * * * *
```
- 宠汪汪同样使用`JDHelloWorld`的仓库，禁用其他的只跑`宠汪汪二代目`即可
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

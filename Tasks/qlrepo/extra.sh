#!/usr/bin/env bash

## 添加你需要重启自动执行的任意命令，比如 ql repo
## 定时任务-添加定时-命令：ql extra-定时规则自定-运行
## 推荐配置如下，自行注释和取消注释、修改 cron 使用

# 整库
# 1. Unknown 备份托管等
## (1) JDHelloWorld
## ql repo https://github.com/JDHelloWorld/jd_scripts.git "jd_|jx_|getJDCookie" "activity|backUp|Coupon|enen|update" "^jd[^_]|USER"
## (2) he1pu（自动提交助力码-京喜工厂、种豆得豆、东东工厂、东东农场、健康社区、京喜财富岛、东东萌宠、闪购盲盒，随机从数据库中选取助力码互助）
## ql repo https://github.com/he1pu/JDHelp.git "jd_|jx_|getJDCookie" "activity|backUp|Coupon|update" "^jd[^_]|USER|MovementFaker|JDJRValidator_Pure|sign_graphics_validate|ZooFaker_Necklace"
## (3) shufflewzc
ql repo https://github.com/shufflewzc/faker2.git "jd_|jx_|getJDCookie" "activity|backUp" "^jd[^_]|USER|ZooFaker_Necklace|JDJRValidator_Pure"
## (4) panghu999
## ql repo https://github.com/panghu999/jd_scripts.git "jd_|jx_|getJDCookie" "activity|backUp|Coupon|jd_try|format_" "^jd[^_]|USER"
## (5) chinnkarahoi
## ql repo https://github.com/chinnkarahoi/jd_scripts.git "jd_|jx_|getJDCookie" "activity|backUp|Coupon" "^jd[^_]|USER"

# 2. passerby-b
## ql repo https://github.com/passerby-b/JDDJ.git "jddj_" "scf_test_event" "jddj_cookie"

# 3. curtinlv
## ql repo https://github.com/curtinlv/JD-Script.git

# 4. smiek2221
## ql repo https://github.com/smiek2221/scripts.git "jd_" "" "^MovementFaker|^JDJRValidator|^sign"

# 5. cdle
## ql repo https://github.com/cdle/jd_study.git "jd_"

# 6. ZCY01
## ql repo https://github.com/ZCY01/daily_scripts.git "jd_"

# 7. whyour/hundun
## ql repo https://github.com/whyour/hundun.git "quanx" "tokens|caiyun|didi|donate|fold|Env"

# 8. moposmall
## ql repo https://github.com/moposmall/Script.git "Me"

# 9. Ariszy (Zhiyi-N)
## ql repo https://github.com/Ariszy/Private-Script.git "JD"

# 10. photonmang（宠汪汪及兑换、点点券修复）
## ql repo https://github.com/photonmang/quantumultX.git "JDscripts"

# 11. jiulan
## ql repo https://github.com/jiulan/platypus.git

# 12. panghu999/panghu
## ql repo https://github.com/panghu999/panghu.git "jd_"

# 13. star261
## ql repo https://github.com/star261/jd.git "jd_|star" "" "^MovementFaker"

# 14. Wenmoux
## ql repo https://github.com/Wenmoux/scripts.git "other|jd" "" "" "wen"

# 单脚本
## 名称之后标注﹢的单脚本，若上面已拉取仓库的可以不拉，否则会重复拉取。这里适用于只拉取部分脚本使用
# 1. curtinlv﹢
## 抢京豆 0 0 * * *
## ql raw https://raw.githubusercontent.com/curtinlv/JD-Script/main/jd_qjd.py
## 入会 15 8 * * *
## ql raw https://raw.githubusercontent.com/curtinlv/JD-Script/main/OpenCard/jd_OpenCard.py
## 关注 15 8 * * *
## ql raw https://raw.githubusercontent.com/curtinlv/JD-Script/main/getFollowGifts/jd_getFollowGift.py

# 2. chiupam
## 京喜工厂瓜分电力开团 ID
## ql repo https://github.com/chiupam/JD_Diy.git "activeId"

# 依赖
# 适用于柠檬胖虎代维护 lxk0301 仓库，宠汪汪二代目和宠汪汪兑换，只支持国内机。
apk add --no-cache build-base g++ cairo-dev pango-dev giflib-dev && cd scripts && npm install canvas --build-from-source
# 适用于 JDHelloWorld 和 he1pu 的宠汪汪二代目和宠汪汪兑奖品二代目
cd scripts && npm install png-js -S
# 财富岛依赖安装命令
## 安装 date-fns
npm install date-fns -S
## 安装 axios
npm install axios -S
## 安装 crypto-js
npm install crypto-js -S
## 安装 ts-md5
npm install ts-md5 -S
## 安装 tslib
npm install tslib -S
## 安装 @types/node
npm install @types/node -S
## Python 3 安装 requests
pip3 install requests
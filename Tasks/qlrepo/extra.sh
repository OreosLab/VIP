#!/usr/bin/env bash

## 添加你需要重启自动执行的任意命令，比如 ql repo
## 定时任务-添加定时-命令：ql extra-定时规则：0-运行
## 推荐配置如下，自行注释和取消注释、修改 cron 使用

# 整库
# 1. Unknown 备份托管等
## (1) JDHelloWorld
ql repo https://github.com/JDHelloWorld/jd_scripts.git "jd_|jx_|getJDCookie" "activity|backUp|Coupon|enen|update" "^jd[^_]|USER" 1 0-23/4 * * *
## (2) he1pu（自动提交助力码-京喜工厂、种豆得豆、东东工厂、东东农场、健康社区、京喜财富岛、东东萌宠、闪购盲盒，随机从数据库中选取助力码互助）
## ql repo https://github.com/he1pu/JDHelp.git "jd_|jx_|getJDCookie" "Coupon|update" "^jd[^_]|USER" 1 0-23/4 * * *
## (3) shufflewzc
## ql repo https://github.com/shufflewzc/faker2.git "jd_|jx_|getJDCookie" "activity|backUp|Coupon|update" "^jd[^_]|USER" 1 0-23/4 * * *
## (4) panghu999
## ql repo https://github.com/panghu999/jd_scripts.git "jd_|jx_|getJDCookie" "activity|backUp|Coupon|jd_try|format_" "^jd[^_]|USER" 1 0-23/4 * * *
## (5) chinnkarahoi
## ql repo https://github.com/chinnkarahoi/jd_scripts.git "jd_|jx_|getJDCookie" "activity|backUp|Coupon" "^jd[^_]|USER" 1 0-23/4 * * *

# 2. passerby-b
ql repo https://github.com/passerby-b/JDDJ.git "jddj_" "scf_test_event" "jddj_cookie" 2 0-23/4 * * *

# 3. curtinlv
ql repo https://github.com/curtinlv/JD-Script.git 3 0-23/4 * * *

# 4. smiek2221
ql repo https://github.com/smiek2221/scripts.git "jd_" "" "^MovementFaker|^JDJRValidator|^sign" 4 0-23/4 * * *

# 5. cdle
ql repo https://github.com/cdle/jd_study.git "jd_" 5 0-23/4 * * *

# 6. ZCY01
ql repo https://github.com/ZCY01/daily_scripts.git "jd_" 6 0-23/4 * * *

# 7. whyour/hundun
ql repo https://github.com/whyour/hundun.git "quanx" "tokens|caiyun|didi|donate|fold|Env" 7 0-23/4 * * *

# 8. moposmall
ql repo https://github.com/moposmall/Script.git "Me" 8 0-23/4 * * *

# 9. Ariszy (Zhiyi-N)
ql repo https://github.com/Ariszy/Private-Script.git "JD" 9 0-23/4 * * *

# 10. photonmang（宠汪汪及兑换、点点券修复）
ql repo https://github.com/photonmang/quantumultX.git "JDscripts" 10 0-23/4 * * *

# 11. jiulan
ql repo https://github.com/jiulan/platypus.git 11 0-23/4 * * *

# 单脚本
## 名称之后标注﹢的单脚本，若上面已拉取仓库的可以不拉，否则会重复拉取。这里适用于只拉取部分脚本使用
# 1. curtinlv﹢
## 抢京豆 0 0 * * *
## ql raw https://raw.githubusercontent.com/Oreomeow/JD-Script/main/jd_qjd.py 31 0-23/4 * * *
## 入会 15 8 * * *
## ql raw https://raw.githubusercontent.com/curtinlv/JD-Script/main/OpenCard/jd_OpenCard.py 31 0-23/4 * * *
## 关注 15 8 * * *
## ql raw https://raw.githubusercontent.com/curtinlv/JD-Script/main/getFollowGifts/jd_getFollowGift.py 31 0-23/4 * * *

# 2. chiupam
## 京喜工厂瓜分电力开团 ID
ql repo https://github.com/chiupam/JD_Diy.git "activeId" 32 0-23/4 * * *
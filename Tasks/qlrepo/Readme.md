# 青龙拉取常用京东脚本库
## 说明
- 更新一个整库脚本
```
ql repo <repourl> <path> <blacklist> <dependence> <branch>
```
- 更新单个脚本文件
```
ql raw <fileurl>
```
下面是示例

## 整库
- `Unknown 备份托管等`

  1. `panghu999`（主用）
  ```
  ql repo https://github.com/panghu999/jd_scripts.git "jd_|jx_|getJDCookie" "activity|backUp|jd_delCoupon|format_" "^jd[^_]|USER"
  ```
  - cron
  ```
  50 * * * *
  ```
  2. `JDHelloWorld`（辅助）
  ```
  ql repo https://github.com/JDHelloWorld/jd_scripts.git "jd_|jx_|getJDCookie" "activity|backUp|jd_delCoupon" "^jd[^_]|USER"
  ```
  - cron
  ```
  55 * * * *
  ```
  3. `chinnkarahoi`
  ```
  ql repo https://github.com/chinnkarahoi/jd_scripts.git "jd_|jx_|getJDCookie" "activity|backUp|jd_delCoupon" "^jd[^_]|USER"
  ```
  4. `he1pu`（自动提交助力码-京喜工厂、种豆得豆、东东工厂、东东农场、健康社区、京喜财富岛、东东萌宠、闪购盲盒，随机从数据库中选取助力码互助）
  ```
  ql repo https://github.com/he1pu/JDHelp.git "jd_|jx_|getJDCookie" "activity|backUp|jd_delCoupon" "^jd[^_]|USER"
  ```
  
- `longzhuzhu`
```
ql repo https://github.com/longzhuzhu/nianyu.git "qx"
```
- `whyour/hundun`
```
ql repo https://github.com/whyour/hundun.git "quanx" "tokens|caiyun|didi|donate|fold|Env"
```
- `passerby-b`
```
ql repo https://github.com/passerby-b/JDDJ.git "jddj_" "scf_test_event" "jddj_cookie"
```
- `Wenmoux`
```
ql repo https://github.com/Wenmoux/scripts.git "other|jd" "" "" "wen"
```
- `panghu999/panghu`
```
ql repo https://github.com/panghu999/panghu.git "jd_"
```
- `zoopanda`
```
ql repo https://github.com/zooPanda/zoo.git "zoo"
```
- `hyzaw`
```
ql repo https://github.com/hyzaw/scripts.git "ddo_"
```
- `Ariszy (Zhiyi-N)`
```
ql repo https://github.com/Ariszy/Private-Script.git "JD"
```
- `ZCY01`
```
ql repo https://github.com/ZCY01/daily_scripts.git "jd_"
```
- `monk-dust/dust`
```
ql repo https://github.com/Oreomeow/dust.git "i-chenzhe|normal|member|car" "backup"
```
- `star261`
```
ql repo https://github.com/star261/jd.git "scripts" "code" 
```
- `curtinlv`
```
ql repo https://github.com/curtinlv/JD-Script.git
```
- `moposmall`
```
ql repo https://github.com/moposmall/Script.git "Me"
```

## 单脚本
> 翻翻乐提现单文件
```
ql raw https://raw.githubusercontent.com/jiulan/platypus/main/scripts/jd_ffl.js
```
> `curtinlv`（上面拉过仓库的可以不用拉了）
```
15 8 * * *
```
>> 赚京豆
```
ql raw https://raw.githubusercontent.com/curtinlv/JD-Script/main/jd_zjd.py
```
>> 入会
```
ql raw https://raw.githubusercontent.com/curtinlv/JD-Script/main/OpenCard/jd_OpenCard.py
```
>> 关注
```
ql raw https://raw.githubusercontent.com/curtinlv/JD-Script/main/getFollowGifts/jd_getFollowGift.py
```

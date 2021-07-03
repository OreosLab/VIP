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
  
  1. `JDHelloWorld`
  ```
  ql repo https://github.com/JDHelloWorld/jd_scripts.git "jd_|jx_|getJDCookie" "activity|backUp|Coupon|enen" "^jd[^_]|USER"
  ```
  2. `chinnkarahoi`
  ```
  ql repo https://github.com/chinnkarahoi/jd_scripts.git "jd_|jx_|getJDCookie" "activity|backUp|Coupon" "^jd[^_]|USER"
  ```
  3. `he1pu`（自动提交助力码-京喜工厂、种豆得豆、东东工厂、东东农场、健康社区、京喜财富岛、东东萌宠、闪购盲盒，随机从数据库中选取助力码互助）
  ```
  ql repo https://github.com/he1pu/JDHelp.git "jd_|jx_|getJDCookie" "activity|backUp|jd_delCoupon" "^jd[^_]|USER"
  ```
  

- `whyour/hundun`
```
ql repo https://github.com/whyour/hundun.git "quanx" "tokens|caiyun|didi|donate|fold|Env"
```
- `passerby-b`
```
ql repo https://github.com/passerby-b/JDDJ.git "jddj_" "scf_test_event" "jddj_cookie"
```
- `Ariszy (Zhiyi-N)`
```
ql repo https://github.com/Ariszy/Private-Script.git "JD"
```
- `ZCY01`
```
ql repo https://github.com/ZCY01/daily_scripts.git "jd_"
```
- `curtinlv`
```
ql repo https://github.com/curtinlv/JD-Script.git
```
- `moposmall`
```
ql repo https://github.com/moposmall/Script.git "Me"
```
- `photonmang`（宠汪汪及兑换、点点券修复）
```
ql repo https://github.com/photonmang/quantumultX.git "JDscripts"
```

## 单脚本
### 名称之后标注`﹢`的单脚本，若上面已拉取仓库的可以不拉，否则会重复拉取。这里适用于只拉取部分脚本使用
> `curtinlv`﹢

>> 抢京豆
```
ql raw https://raw.githubusercontent.com/Oreomeow/JD-Script/main/jd_qjd.py
```
>> 入会
```
ql raw https://raw.githubusercontent.com/curtinlv/JD-Script/main/OpenCard/jd_OpenCard.py
```
>> 关注
```
ql raw https://raw.githubusercontent.com/curtinlv/JD-Script/main/getFollowGifts/jd_getFollowGift.py
```

## 已删库存档
- `monk-coder`
```
ql repo https://github.com/monk-dust/dust.git "i-chenzhe|normal|member|car" "backup"
```
- `hyzaw`
```
ql repo https://github.com/hyzaw/scripts.git "ddo_"
```
- `Wenmoux`
```
ql repo https://github.com/Wenmoux/scripts.git "other|jd" "" "" "wen"
```
- `zooPanda`
```
ql repo https://github.com/zooPanda/zoo.git "zoo"
```
- `star261`
```
ql repo https://github.com/star261/jd.git "scripts" "code" 
```
- `panghu999`
```
ql repo https://github.com/panghu999/jd_scripts.git "jd_|jx_|getJDCookie" "activity|backUp|Coupon|format_" "^jd[^_]|USER"
```
- `longzhuzhu`
```
ql repo https://github.com/longzhuzhu/nianyu.git "qx"
```
- `panghu999/panghu`
```
ql repo https://github.com/panghu999/panghu.git "jd_"
```
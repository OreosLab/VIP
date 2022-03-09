# 青龙拉取常用京东脚本库

## 说明

- 更新一个整库脚本

```sh
ql repo <repourl> <path> <blacklist> <dependence> <branch>
```

- 更新单个脚本文件

```sh
ql raw <fileurl>
```

下面是示例

## 整库

- `Unknown 备份托管等`
  
1. `JDHelloWorld`

    ```sh
    ql repo https://github.com/JDHelloWorld/jd_scripts.git "jd_|jx_|getJDCookie" "activity|backUp|Coupon|enen|update|test" "^jd[^_]|USER|^TS|utils|notify|env|package|ken.js"
    ```

2. `he1pu`（自动提交助力码-京喜工厂、种豆得豆、东东工厂、东东农场、健康社区、京喜财富岛、东东萌宠、闪购盲盒，随机从数据库中选取助力码互助）

    ```sh
    ql repo https://github.com/he1pu/JDHelp.git "jd_|jx_|getJDCookie" "Coupon|update" "^jd[^_]|USER|^sign|^ZooFaker|utils"
    ```

3. `shufflewzc`

    ```sh
    ql repo https://github.com/shufflewzc/faker2.git "jd_|jx_|gua_|jddj_|getJDCookie" "activity|backUp|Coupon|update" "^jd[^_]|USER|utils|function|^JS|^TS|^JDJRValidator_Pure|^ZooFaker|^sign|ql"
    ```

4. `Aaron-lv`

    ```sh
    ql repo https://github.com/Aaron-lv/sync.git "jd_|jx_|getJDCookie" "activity|backUp|Coupon" "^jd[^_]|USER|utils" "jd_scripts"
    ```

5. `panghu999`（无维护）

    ```sh
    ql repo https://github.com/panghu999/jd_scripts.git "jd_|jx_|getJDCookie" "activity|backUp|Coupon|jd_try|format_" "^jd[^_]|USER"
    ```

6. `chinnkarahoi`（无维护）

    ```sh
    ql repo https://github.com/chinnkarahoi/jd_scripts.git "jd_|jx_|getJDCookie" "activity|backUp|Coupon" "^jd[^_]|USER"
    ```

- `passerby-b`

```sh
ql repo https://github.com/passerby-b/JDDJ.git "jddj_" "scf_test_event|jddj_fruit_code.js|jddj_getck.js|jd_|jddj_cookie"
```

- `curtinlv`

```sh
ql repo https://github.com/curtinlv/JD-Script.git "jd_"
```

- `smiek2221`

```sh
ql repo https://github.com/smiek2121/scripts.git "jd_|gua_" "" "^MovementFaker|^JDJRValidator|^ZooFaker|^sign|^cleancart" 
```

- `cdle`

```sh
ql repo https://github.com/cdle/xdd.git "jd_" "disposable|expired|jdc"
```

- `ZCY01`

```sh
ql repo https://github.com/ZCY01/daily_scripts.git "jd_"
```

- `whyour/hundun`

```sh
ql repo https://github.com/whyour/hundun.git "quanx" "tokens|caiyun|didi|donate|fold|Env"
```

- `moposmall`

```sh
ql repo https://github.com/moposmall/Script.git "Me"
```

- `Ariszy (Zhiyi-N)`

```sh
ql repo https://github.com/Ariszy/Private-Script.git "JD"
```

- `photonmang`（宠汪汪及兑换、点点券修复）

```sh
ql repo https://github.com/photonmang/quantumultX.git "JDscripts"
```

- `jiulan`

```sh
ql repo https://github.com/jiulan/platypus.git "jd_|jx_" "" "overdue" "main"
```

- `star261`

```sh
ql repo https://github.com/star261/jd.git "jd_|star" "" "code" "main"
```

- `Wenmoux`

```sh
ql repo https://github.com/Wenmoux/scripts.git "other|jd" "" "" "wen"
```

- `Tsukasa007`

```sh
ql repo https://github.com/Tsukasa007/my_script.git "jd_|jx_" "jdCookie|USER_AGENTS|sendNotify|backup" "" "master"
```

## 单脚本

### 名称之后标注`﹢`的单脚本，若上面已拉取仓库的可以不拉，否则会重复拉取。这里适用于只拉取部分脚本使用

> `curtinlv`﹢

- 入会

```sh
ql raw https://raw.githubusercontent.com/curtinlv/JD-Script/main/OpenCard/jd_OpenCard.py
```

- 关注

```sh
ql raw https://raw.githubusercontent.com/curtinlv/JD-Script/main/getFollowGifts/jd_getFollowGift.py
```

> `chiupam`

- 京喜工厂瓜分电力开团 ID

```sh
ql raw https://raw.githubusercontent.com/chiupam/JD_Diy/master/pys/activeId.py
```

> `Aaron-lv`+

- 财富岛

```sh
ql raw https://raw.githubusercontent.com/Aaron-lv/sync/jd_scripts/jd_cfd.js
```

or

```sh
ql repo https://github.com/Aaron-lv/sync.git "jd_cfd" "" "" "jd_scripts"
```

> `Wenmoux`+

- 口袋书店

```sh
ql raw https://raw.githubusercontent.com/Wenmoux/scripts/wen/jd/chinnkarahoi_jd_bookshop.js
```

or

```sh
ql repo https://github.com/Wenmoux/scripts.git "chinnkarahoi_jd_bookshop" "" "" "wen"
```

> `NobyDa`

- 京东多合一签到脚本

```sh
ql raw https://raw.githubusercontent.com/NobyDa/Script/master/JD-DailyBonus/JD_DailyBonus.js
```

or

```sh
ql repo https://github.com/NobyDa/Script.git "JD-DailyBonus" "" "JD_DailyBonus" "master"
```

## 已删库存档

- `monk-coder`

```sh
ql repo https://github.com/monk-dust/dust.git "i-chenzhe|normal|member|car" "backup"
```

- `hyzaw`

```sh
ql repo https://github.com/hyzaw/scripts.git "ddo_"
```

- `zooPanda`

```sh
ql repo https://github.com/zooPanda/zoo.git "zoo"
```

- `longzhuzhu`

```sh
ql repo https://github.com/longzhuzhu/nianyu.git "qx"
```

- `panghu999/panghu`

```sh
ql repo https://github.com/panghu999/panghu.git "jd_"
```

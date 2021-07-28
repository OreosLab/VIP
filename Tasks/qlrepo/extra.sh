#!/usr/bin/env bash
## Mod: Build20210729V1
## 添加你需要重启自动执行的任意命令，比如 ql repo
## 安装node依赖使用 pnpm install -g xxx xxx（Build 20210728-002 及以上版本的 code.sh，可忽略）
## 安装python依赖使用 pip3 install xxx（Build 20210728-002 及以上版本的 code.sh，可忽略）

## 使用方法
## 1.拉取仓库
### （1）定时任务→添加定时→命令【ql extra】→定时规则【15 0-23/4 * * *】extra】→运行
### （2）若运行过 1custom 一键脚本，点击运行即可
### （3）推荐配置：如下。自行在需要的命令前注释和取消注释 ##，该文件最前的 # 勿动
## 2.安装依赖
### （1）默认不安装，因为Build 20210728-002 及以上版本的 code.sh 自动检查修复依赖
### （2）若需要在此处使用，请删除依赖附近的注释

## 预设仓库和参数（u=url，p=path，k=blacklist，d=dependence，b=branch），如果懂得定义可以自行修改
## （1）预设的 panghu999 仓库
u1="https://github.com/panghu999/jd_scripts.git"
p1="jd_|jx_|getJDCookie"
k1="activity|backUp|Coupon|jd_try|format_"
d1="^jd[^_]|USER"
## （2）预设的 JDHelloWorld 仓库
u2="https://github.com/JDHelloWorld/jd_scripts.git"
p2="jd_|jx_|getJDCookie"
k2="activity|backUp|Coupon|enen|update|test"
d2="^jd[^_]|USER|^TS|utils|notify|env|package|ken.js"
## （3）预设的 he1pu 仓库
u3="https://github.com/he1pu/JDHelp.git"
p3="jd_|jx_|getJDCookie"
k3="activity|backUp|Coupon|update"
d3="^jd[^_]|USER|utils|^MovementFaker|^JDJRValidator|^sign|^ZooFaker"
## （4）预设的 shufflewzc 仓库
u4="https://github.com/shufflewzc/faker2.git"
p4="jd_|jx_|gua_|jddj_|getJDCookie"
k4="activity|backUp|update"
d4="^jd[^_]|USER|utils|^ZooFaker|^JDJRValidator|^sign"
## （6）预设的 Aaron-lv 仓库
u6="https://github.com/Aaron-lv/sync.git"
p6="jd_|jx_|getJDCookie"
k6="activity|backUp|Coupon"
d6="^jd[^_]|USER|utils"
b6="jd_scripts"
## 默认拉取仓库参数集合
default1="$u1 $p1 $k1 $d1"
default2="$u2 $p2 $k2 $d2"
default3="$u3 $p3 $k3 $d3"
default4="$u4 $p4 $k4 $d4"
default6="$u6 $p6 $k6 $d6 $b6"
## 默认拉取仓库编号设置
default=$default4 ##此处修改，只改数字，默认 shufflewzc 仓库

# 单脚本
## 名称之后标注﹢的单脚本，若下面已拉取仓库的可以不拉。这里适用于只拉取部分脚本使用
# 1. curtinlv﹢
## 入会 15 8 * * *
## ql raw https://raw.githubusercontent.com/curtinlv/JD-Script/main/OpenCard/jd_OpenCard.py
## 关注 15 8 * * *
## ql raw https://raw.githubusercontent.com/curtinlv/JD-Script/main/getFollowGifts/jd_getFollowGift.py

# 2. chiupam
## 京喜工厂瓜分电力开团 ID
## ql raw https://raw.githubusercontent.com/chiupam/JD_Diy/master/pys/activeId.py

# 3. Aaron-lv
## 财富岛
## ql raw https://raw.githubusercontent.com/Aaron-lv/sync/jd_scripts/jd_cfd.js
## ql repo https://github.com/Aaron-lv/sync.git "jd_cfd" "" "" "jd_scripts"

# 4. Wenmoux
## 口袋书店
## ql raw https://raw.githubusercontent.com/Wenmoux/scripts/wen/jd/chinnkarahoi_jd_bookshop.js
## ql repo https://github.com/Wenmoux/scripts.git "chinnkarahoi_jd_bookshop" "" "" "wen"

# 5. NobyDa
## 京东多合一签到脚本
## ql repo https://github.com/NobyDa/Script.git "JD-DailyBonus" "" "JD_DailyBonus" "master"

# 整库
# 1. Unknown 备份托管等（如上）
ql repo $default ##此处勿动

# 2. passerby-b
## ql repo https://github.com/passerby-b/JDDJ.git "jddj_" "scf_test_event|jddj_fruit_code.js|jddj_getck.js|jd_|jddj_cookie"

# 3. curtinlv
## ql repo https://github.com/curtinlv/JD-Script.git "jd_"

# 4. smiek2221
## ql repo https://github.com/smiek2221/scripts.git "jd_|gua_" "" "^ZooFaker|^JDJRValidator|^sign"

# 5. cdle
## ql repo https://github.com/cdle/jd_study.git "jd_" "expired"

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
## ql repo https://github.com/star261/jd.git "jd_|star" "" "code" "main"

# 14. Wenmoux
## ql repo https://github.com/Wenmoux/scripts.git "other|jd" "" "" "wen"


# 依赖
:<<\EOF #取消注释请删除该行和后面提到的一行
package_name="canvas png-js date-fns axios crypto-js ts-md5 tslib @types/node dotenv typescript fs require tslib"

install_dependencies_normal(){
    for i in $@; do
        case $i in
            canvas)
                cd /ql/scripts
                if [[ "$(echo $(npm ls $i) | grep ERR)" != "" ]]; then
                    npm uninstall $i
                fi
                if [[ "$(npm ls $i)" =~ (empty) ]]; then
                    apk add --no-cache build-base g++ cairo-dev pango-dev giflib-dev && npm i $i --prefix /ql/scripts --build-from-source
                fi
                ;;
            *)
                if [[ "$(npm ls $i)" =~ $i ]]; then
                    npm uninstall $i
                elif [[ "$(echo $(npm ls $i -g) | grep ERR)" != "" ]]; then
                    npm uninstall $i -g
                fi
                if [[ "$(npm ls $i -g)" =~ (empty) ]]; then
                    [[ $i = "typescript" ]] && npm i $i -g --force || npm i $i -g
                fi
                ;;
        esac
    done
}

install_dependencies_force(){
    for i in $@; do
        case $i in
            canvas)
                cd /ql/scripts
                if [[ "$(npm ls $i)" =~ $i && "$(echo $(npm ls $i) | grep ERR)" != "" ]]; then
                    npm uninstall $i
                    rm -rf /ql/scripts/node_modules/$i
                    rm -rf /usr/local/lib/node_modules/lodash/*
                fi
                if [[ "$(npm ls $i)" =~ (empty) ]]; then
                    apk add --no-cache build-base g++ cairo-dev pango-dev giflib-dev && npm i $i --prefix /ql/scripts --build-from-source --force
                fi
                ;;
            *)
                cd /ql/scripts
                if [[ "$(npm ls $i)" =~ $i ]]; then
                    npm uninstall $i
                    rm -rf /ql/scripts/node_modules/$i
                    rm -rf /usr/local/lib/node_modules/lodash/*
                elif [[ "$(npm ls $i -g)" =~ $i && "$(echo $(npm ls $i -g) | grep ERR)" != "" ]]; then
                    npm uninstall $i -g
                    rm -rf /ql/scripts/node_modules/$i
                    rm -rf /usr/local/lib/node_modules/lodash/*
                fi
                if [[ "$(npm ls $i -g)" =~ (empty) ]]; then
                    npm i $i -g --force
                fi
                ;;
        esac
    done
}

install_dependencies_all(){
    install_dependencies_normal $package_name
    for i in $package_name; do
        install_dependencies_force $i
    done
}

install_dependencies_all &
EOF #取消注释请删除该行和前面提到的一行
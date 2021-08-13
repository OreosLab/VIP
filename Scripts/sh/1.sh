#!/usr/bin/env bash

log() {
    echo -e "\e[32m\n$1 \e[0m\n"
}

inp() {
    echo -e "\e[33m\n$1 \e[0m\n"
}

opt(){
    echo -n -e "\e[36m输入您的选择->\e[0m"
}

warn() {
        echo -e "\e[31m$1 \e[0m\n"
        }
}

warn "大道至简"
inp "选择你想部署的 docker 项目：\n1) qinglong 2) V4 3) elecV2P 4) HHL 5) JS_TOOL 6) helloword(sakura)"
read option
case $option in
    1) project="ql"
    ;;
    2) project="v4"
    ;;
    3) project="v2p"
    ;;
    4) project="hhl"
    ;;
    *) echo -e "\e[31m还没写好或不存在\e[0m\n"
esac

wget -q https://raw.githubusercontent.com/Oreomeow/VIP/main/Scripts/sh/${project}.sh -O ${project}.sh
bash ${project}.sh

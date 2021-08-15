#!/usr/bin/env bash

clear

echo "
┏━┓┏┓╻┏━╸   ╻┏ ┏━╸╻ ╻   ┏━┓╻ ╻┏━╸╻  ╻     ┏━╸┏━┓┏━┓   ╺┳┓┏━┓┏━╸╻┏ ┏━╸┏━┓
┃ ┃┃┗┫┣╸ ╺━╸┣┻┓┣╸ ┗┳┛   ┗━┓┣━┫┣╸ ┃  ┃     ┣╸ ┃ ┃┣┳┛    ┃┃┃ ┃┃  ┣┻┓┣╸ ┣┳┛
┗━┛╹ ╹┗━╸   ╹ ╹┗━╸ ╹    ┗━┛╹ ╹┗━╸┗━╸┗━╸   ╹  ┗━┛╹┗╸   ╺┻┛┗━┛┗━╸╹ ╹┗━╸╹┗╸
"

log(){
    echo -e "\e[32m\n$1 \e[0m\n"
}

inp(){
    echo -e "\e[33m\n$1 \e[0m\n"
}

opt(){
    echo -n -e "\e[36m输入您的选择->\e[0m"
}

warn(){
    echo -e "\e[31m$1 \e[0m\n"
}

docker_install() {
    echo "检测 Docker......"
    if [ -x "$(command -v docker)" ]; then
        echo "检测到 Docker 已安装!"
    else
        if [ -r /etc/os-release ]; then
            lsb_dist="$(. /etc/os-release && echo "$ID")"
        fi
        if [ $lsb_dist == "openwrt" ]; then
            echo "openwrt 环境请自行安装 docker"
            exit 1
        else
            echo "安装 docker 环境..."
            curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
            echo "安装 docker 环境...安装完成!"
            systemctl enable docker
            systemctl start docker
        fi
    fi
}

Onekey(){
    wget -q https://raw.githubusercontent.com/Oreomeow/VIP/main/Scripts/sh/$1.sh -O $1.sh && bash $1.sh
}

INSTALL_JS_TOOL(){
    echo -e "\n"
    docker_install
    inp "是否直接安装：\n1) 直接安装[默认]\n2) 手动选择"
    opt
    read type
    if [ "$type" = "2" ]; then
        wget -q https://gitee.com/highdimen/js_tool/raw/A1/resource/install_scripts/docker_install_jd.sh -O docker_install_jd.sh && chmod +x docker_install_jd.sh && bash docker_install_jd.sh
    else
        wget -q https://gitee.com/highdimen/js_tool/raw/A1/resource/install_scripts/Qunhui_docker_install_jd.sh -O docker_install_jd.sh && chmod +x docker_install_jd.sh && bash docker_install_jd.sh
    fi
}

log "大道至简"
inp "选择你想部署的 docker 项目：\n1) qinglong\n2) V4\n3) elecV2P\n4) HHL\n5) JS_TOOL"
opt
read option
case $option in
    1)  Onekey "ql"
    ;;
    2)  Onekey "v4"
    ;;
    3)  Onekey "v2p"
    ;;
    4)  Onekey "hhl"
    ;;
    5)  INSTALL_JS_TOOL
    ;;  
    *)  warn "该项目不存在"
    ;;
esac
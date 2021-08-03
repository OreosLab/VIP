#!/bin/sh

clear

echo -e "\033[36m

   ▄▄▄▄       ██                         ▄▄▄▄                                   
  ██▀▀██      ▀▀                         ▀▀██                                   
 ██    ██   ████     ██▄████▄   ▄███▄██    ██       ▄████▄   ██▄████▄   ▄███▄██ 
 ██    ██     ██     ██▀   ██  ██▀  ▀██    ██      ██▀  ▀██  ██▀   ██  ██▀  ▀██ 
 ██    ██     ██     ██    ██  ██    ██    ██      ██    ██  ██    ██  ██    ██ 
  ██▄▄██▀  ▄▄▄██▄▄▄  ██    ██  ▀██▄▄███    ██▄▄▄   ▀██▄▄██▀  ██    ██  ▀██▄▄███ 
   ▀▀▀██   ▀▀▀▀▀▀▀▀  ▀▀    ▀▀   ▄▀▀▀ ██     ▀▀▀▀     ▀▀▀▀    ▀▀    ▀▀   ▄▀▀▀ ██ 
       ▀                        ▀████▀▀                                 ▀████▀▀
"
DOCKER_IMG_NAME="whyour/qinglong"
JD_PATH=""
SHELL_FOLDER=$(pwd)
CONTAINER_NAME=""
TAG="latest"
NETWORK="host"
JD_PORT=5700
NINJA_PORT=5701

HAS_IMAGE=false
PULL_IMAGE=true
HAS_CONTAINER=false
DEL_CONTAINER=true
INSTALL_WATCH=false
ENABLE_WEB_PANEL=true
ENABLE_HANGUP=true
OLD_IMAGE_ID=""
ENABLE_HANGUP_ENV="--env ENABLE_HANGUP=true"
ENABLE_WEB_PANEL_ENV="--env ENABLE_WEB_PANEL=true"


log() {
    echo -e "\e[32m$1 \e[0m\n"
}

inp() {
    echo -e "\e[33m\n$1 \e[0m\n"
}

warn() {
    echo -e "\e[31m$1 \e[0m\n"
}

cancelrun() {
    if [ $# -gt 0 ]; then
        echo     "\033[31m $1 \033[0m"
    fi
    exit 1
}

docker_install() {
    echo "检查Docker......"
    if [ -x "$(command -v docker)" ]; then
       echo "检查到Docker已安装!"
    else
       if [ -r /etc/os-release ]; then
            lsb_dist="$(. /etc/os-release && echo "$ID")"
        fi
        if [ $lsb_dist == "openwrt" ]; then
            echo "openwrt 环境请自行安装docker"
            #exit 1
        else
            echo "安装docker环境..."
            curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
            echo "安装docker环境...安装完成!"
            systemctl enable docker
            systemctl start docker
        fi
    fi
}

docker_install
warn "降低学习成本，小白回车到底，一路默认选择"
#配置文件目录
echo -n -e "\e[33m一.请输入配置文件保存的绝对路径,直接回车为当前目录:\e[0m"
read jd_path
JD_PATH=$jd_path
if [ -z "$jd_path" ]; then
    JD_PATH=$SHELL_FOLDER
fi
CONFIG_PATH=$JD_PATH/ql/config
DB_PATH=$JD_PATH/ql/db
REPO_PATH=$JD_PATH/ql/repo
RAW_PATH=$JD_PATH/ql/raw
SCRIPT_PATH=$JD_PATH/ql/scripts
LOG_PATH=$JD_PATH/ql/log
JBOT_PATH=$JD_PATH/ql/jbot
NINJA_PATH=$JD_PATH/ql/ninja


#检测镜像是否存在
if [ ! -z "$(docker images -q $DOCKER_IMG_NAME:$TAG 2> /dev/null)" ]; then
    HAS_IMAGE=true
    OLD_IMAGE_ID=$(docker images -q --filter reference=$DOCKER_IMG_NAME:$TAG)
    inp "检测到先前已经存在的镜像，是否拉取最新的镜像：\n1) 是[默认]\n2) 不需要"
    echo -n -e "\e[36m输入您的选择->\e[0m"
    read update
    if [ "$update" = "2" ]; then
        PULL_IMAGE=false
    fi
fi

#检测容器是否存在
check_container_name() {
    if [ ! -z "$(docker ps -a | grep $CONTAINER_NAME 2> /dev/null)" ]; then
        HAS_CONTAINER=true
        inp "检测到先前已经存在的容器，是否删除先前的容器：\n1) 是[默认]\n2) 不要"
        echo -n -e "\e[36m输入您的选择->\e[0m"
        read update
        if [ "$update" = "2" ]; then
            PULL_IMAGE=false
            inp "您选择了不要删除之前的容器，需要重新输入容器名称"
            input_container_name
        fi
    fi
}

#容器名称
input_container_name() {
    echo -n -e "\e[33m三.请输入要创建的Docker容器名称[默认为：qinglong]->\e[0m"
    read container_name
    if [ -z "$container_name" ]; then
        CONTAINER_NAME="jd_v4_bot"
    else
        CONTAINER_NAME=$container_name
    fi
    check_container_name
}
input_container_name


#是否安装WatchTower
inp "5.是否安装containrrr/watchtower自动更新Docker容器：\n1) 安装\n2) 不安装[默认]"
echo -n -e "\e[33m输入您的选择->\e[0m"
read watchtower
if [ "$watchtower" = "1" ]; then
    INSTALL_WATCH=true
fi

inp "请选择容器的网络类型：\n1) host[默认]\n2) bridge"
echo -n -e "\e[36m输入您的选择->\e[0m"
read net
if [ "$net" = "2" ]; then
    NETWORK="bridge"
fi

inp "是否在启动容器时自动启动挂机程序：\n1) 开启[默认]\n2) 关闭"
echo -n -e "\e[36m输入您的选择->\e[0m"
read hang_s
if [ "$hang_s" = "2" ]; then
    ENABLE_HANGUP_ENV=""
fi

inp "是否启用青龙面板：\n1) 启用[默认]\n2) 不启用"
echo -n -e "\e[36m输入您的选择->\e[0m"
read pannel
if [ "$pannel" = "2" ]; then
    ENABLE_WEB_PANNEL_ENV=""
fi

inp "根据设备是否映射端口：\n1) 启用[默认]\n2) 不启用"
echo -n -e "\e[36m输入您的选择->\e[0m"
read port

#配置已经创建完成，开始执行

log "1.开始创建配置文件目录"
mkdir -p $CONFIG_PATH
mkdir -p $DB_PATH
mkdir -p $REPO_PATH
mkdir -p $RAW_PATH
mkdir -p $SCRIPT_PATH
mkdir -p $LOG_PATH
mkdir -p $JBOT_PATH
mkdir -p $NINJA_PATH

if [ $? -ne 0 ] ; then
    cancelrun "** 错误: 目录创建错误请重试！"
fi

if [ $HAS_CONTAINER = true ] && [ $DEL_CONTAINER = true ]; then
    log "2.1.删除先前的容器"
    docker stop $CONTAINER_NAME >/dev/null
    docker rm $CONTAINER_NAME >/dev/null
fi

if [ $HAS_IMAGE = true ] && [ $PULL_IMAGE = true ]; then
    if [ ! -z "$OLD_IMAGE_ID" ] && [ $HAS_CONTAINER = true ] && [ $DEL_CONTAINER = true ]; then
        log "2.2.删除旧的镜像"
        docker image rm $OLD_IMAGE_ID 
    fi
    log "2.3.开始拉取最新的镜像"
    docker pull $DOCKER_IMG_NAME:$TAG
    if [ $? -ne 0 ] ; then
        cancelrun "** 错误: 拉取不到镜像！"
    fi
fi

log "3.开始创建容器并执行"
port(){
docker run -dit \
    -t \
    -v $CONFIG_PATH:/ql/config \
    -v $DB_PATH/ql/db:/ql/db \
    -v $LOG_PATH/ql/log:/ql/log \
    -v $REPO_PATH/ql/repo:/ql/repo \
    -v $RAW_PATH/ql/raw:/ql/raw \
    -v $SCRIPT_PATH/ql/scripts:/ql/scripts \
    -v $JBOT_PATH/ql/jbot:/ql/jbot \
    -v $NINJA_PATH/ql/ninja:/ql/ninja \
    -p $JD_PORT:5700 \
    -p $NINJA_PORT:5701 \
    --name $CONTAINER_NAME \
    --hostname qinglong \
    --restart always \
    --network $NETWORK \
    $ENABLE_HANGUP_ENV \
    $ENABLE_WEB_PANEL_ENV \
    $DOCKER_IMG_NAME:$TAG
}
noport(){
docker run -dit \
    -t \
    -v $CONFIG_PATH:/ql/config \
    -v $DB_PATH/ql/db:/ql/db \
    -v $LOG_PATH/ql/log:/ql/log \
    -v $REPO_PATH/ql/repo:/ql/repo \
    -v $RAW_PATH/ql/raw:/ql/raw \
    -v $SCRIPT_PATH/ql/scripts:/ql/scripts \
    -v $JBOT_PATH/ql/jbot:/ql/jbot \
    -v $NINJA_PATH/ql/ninja:/ql/ninja \
    --name $CONTAINER_NAME \
    --hostname qinglong \
    --restart always \
    --network $NETWORK \
    $ENABLE_HANGUP_ENV \
    $ENABLE_WEB_PANEL_ENV \
    $DOCKER_IMG_NAME:$TAG
}
if [ "$port" = "2" ]; then
    noport
else
    port
fi

if [ $? -ne 0 ] ; then
    cancelrun "** 错误: 容器创建失败，多数由于docker空间不足引起，请检查！"
fi

if [ $INSTALL_WATCH = true ]; then
    log "3.1.开始创建容器并执行"
    docker run -d \
    --name watchtower \
    --restart always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    containrrr/watchtower -c\
    --schedule "13,14,15 3 * * * *" \
    $CONTAINER_NAME
fi

#检查config文件是否存在

if [ ! -f "$CONFIG_PATH/config.sh" ]; then
    docker cp $CONTAINER_NAME:/ql/sample/config.sample.sh $CONFIG_PATH/config.sh
    if [ $? -ne 0 ] ; then
        cancelrun "** 错误: 找不到配置文件！"
    fi
 fi

log "4.下面列出所有容器"
docker ps

log "5.安装已经完成。下面开始青龙内部配置"
docker exec -it $CONTAINER_NAME bash -c "$(curl -fsSL https://gitee.com/allin1code/a1/raw/master/1customCDN.sh)"

log "6.全面部署已完成。enjoy!!!"
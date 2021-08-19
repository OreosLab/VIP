#!/usr/bin/env bash

clear

echo "

 ▄▄    ▄▄  ▄▄    ▄▄  ▄▄       
 ██    ██  ██    ██  ██       
 ██    ██  ██    ██  ██       
 ████████  ████████  ██       
 ██    ██  ██    ██  ██       
 ██    ██  ██    ██  ██▄▄▄▄▄▄ 

"

DOCKER_IMG_NAME="classmatelin/hhl"
JD_PATH=""
SHELL_FOLDER=$(pwd)
CONTAINER_NAME=""
TAG="latest"

HAS_IMAGE=false
EXT_ALL=true
PULL_IMAGE=true
HAS_CONTAINER=false
DEL_CONTAINER=true
INSTALL_WATCH=false
OLD_IMAGE_ID=""

log() {
    echo -e "\e[32m\n$1 \e[0m\n"
}

inp() {
    echo -e "\e[33m\n$1 \e[0m\n"
}

opt() {
    echo -n -e "\e[36m输入您的选择->\e[0m"
}

warn() {
    echo -e "\e[31m$1 \e[0m\n"
}

cancelrun() {
    if [ $# -gt 0 ]; then
        echo -e "\e[31m $1 \e[0m"
    fi
    exit 1
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

# 配置文件保存目录
set_savedir() {
echo -n -e "\e[33m\n一、请输入配置文件保存的绝对路径（示例：/root)，回车默认为当前目录:\e[0m"
read jd_path
if [ -z "$jd_path" ]; then
    JD_PATH=$SHELL_FOLDER
elif [ -d "$jd_path" ]; then
    JD_PATH=$jd_path
else
    mkdir -p $jd_path
    JD_PATH=$jd_path
fi
HHL_PATH=$JD_PATH/hhl
}

docker_install
warn "项目地址：https://github.com/ClassmateLin/jd_scripts"

inp "选择你想拉取的 hhl 镜像：\n1) classmatelin/hhl[默认]\n2) classmatelin/hhl-n1"
opt
read image
if [ "$image" = "2" ]; then
    DOCKER_IMG_NAME="classmatelin/hhl-n1"
fi

inp "是否将目录映射到外部：\n1) 映射[默认]\n2) 不映射"
opt
read ext_all
if [ "$ext_all" = "2" ]; then
    EXT_ALL=false
else
    set_savedir
fi

# 检测镜像是否存在
if [ ! -z "$(docker images -q $DOCKER_IMG_NAME:$TAG 2> /dev/null)" ]; then
    HAS_IMAGE=true
    OLD_IMAGE_ID=$(docker images -q --filter reference=$DOCKER_IMG_NAME:$TAG)
    inp "检测到先前已经存在的镜像，是否拉取最新的镜像：\n1) 拉取[默认]\n2) 不拉取"
    opt
    read update
    if [ "$update" = "2" ]; then
        PULL_IMAGE=false
    fi
fi

# 检测容器是否存在
check_container_name() {
    if [ ! -z "$(docker ps -a | grep $CONTAINER_NAME 2> /dev/null)" ]; then
        HAS_CONTAINER=true
        inp "检测到先前已经存在的容器，是否删除先前的容器：\n1) 删除[默认]\n2) 不删除"
        opt
        read update
        if [ "$update" = "2" ]; then
            PULL_IMAGE=false
            inp "您选择了不删除之前的容器，需要重新输入容器名称"
            input_container_name
        fi
    fi
}

# 容器名称
input_container_name() {
    echo -n -e "\e[33m\n二、请输入要创建的 Docker 容器名称[默认为：hhl]->\e[0m"
    read container_name
    if [ -z "$container_name" ]; then
        CONTAINER_NAME="hhl"
    else
        CONTAINER_NAME=$container_name
    fi
    check_container_name
}
input_container_name

# 是否安装 WatchTower
inp "是否安装 containrrr/watchtower 自动更新 Docker 容器：\n1) 安装\n2) 不安装[默认]"
opt
read watchtower
if [ "$watchtower" = "1" ]; then
    INSTALL_WATCH=true
fi


# 配置已经创建完成，开始执行
if [ $EXT_ALL = true ]; then
    log "1.开始创建配置文件目录"
    mkdir -p $HHL_PATH
    if [ $? -ne 0 ] ; then
    cancelrun "** 错误：目录创建错误请重试！"
    fi
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
        cancelrun "** 错误：拉取不到镜像！"
    fi
fi


log "3.开始创建容器并执行"
run_v() {
    docker run -dit \
        -t \
        -v $HHL_PATH:/scripts \
        --name $CONTAINER_NAME \
        --restart always \
        $DOCKER_IMG_NAME:$TAG
}
run_nov() {
    docker run -dit \
        -t \
        --name $CONTAINER_NAME \
        --restart always \
        $DOCKER_IMG_NAME:$TAG
}
if [ $EXT_ALL = true ]; then
    run_v
else
    run_nov
fi

if [ $? -ne 0 ] ; then
    cancelrun "** 错误：容器创建失败，请翻译以上英文报错，Google/百度尝试解决问题！"
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

log "4.下面列出所有容器"
docker ps

log "5.薅薅乐使用说明：https://github.com/ClassmateLin/jd_scripts#readme"

warn "6.请手动执行一次更新脚本命令 docker exec -it $CONTAINER_NAME /bin/docker-entrypoint"

log "结束后可点一下终端界面，然后按 Ctrl+C 退出\nenjoy!!!"
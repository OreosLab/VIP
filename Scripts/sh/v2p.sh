#!/usr/bin/env bash

clear

echo -e "\e[34m
           mmmm                          mm    mm   mmmmm    mmmmmm   
           \"\"##                          \"##  ##\"  #\"\"\"\"##m  ##\"\"\"\"#m 
  m####m     ##       m####m    m#####m   ##  ##         ##  ##    ## 
 ##mmmm##    ##      ##mmmm##  ##\"    \"   ##  ##       m#\"   ######\"  
 ##\"\"\"\"\"\"    ##      ##\"\"\"\"\"\"  ##          ####      m#\"     ##       
 \"##mmmm#    ##mmm   \"##mmmm#  \"##mmmm#    ####    m##mmmmm  ##       
   \"\"\"\"\"      \"\"\"\"     \"\"\"\"\"     \"\"\"\"\"     \"\"\"\"    \"\"\"\"\"\"\"\"  \"\"       
\e[0m
"

DOCKER_IMG_NAME="elecv2/elecv2p"
V2P_PATH=""
SHELL_FOLDER=$(pwd)
CONTAINER_NAME=""
TAG="latest"
NETWORK="bridge"
V2P_PORT=8100        # webUI 后台管理界面。添加规则/JS 文件管理/定时任务管理/MITM 证书等
HTTP_PORT=8101       # ANYPROXY HTTP 代理端口。（代理端口不是网页，不能通过浏览器直接访问）
REQUEST_PORT=8102    # ANYPROXY 代理请求查看端口

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
read v2p_path
if [ -z "$v2p_path" ]; then
    V2P_PATH=$SHELL_FOLDER
elif [ -d "$v2p_path" ]; then
    V2P_PATH=$v2p_path
else
    mkdir -p $v2p_path
    V2P_PATH=$v2p_path
fi
JSFILE_PATH=$V2P_PATH/elecv2p/JSFile
LISTS_PATH=$V2P_PATH/elecv2p/Lists
STORE_PATH=$V2P_PATH/elecv2p/Store
SHELL_PATH=$V2P_PATH/elecv2p/Shell
ROOTCA_PATH=$V2P_PATH/elecv2p/rootCA
EFSS_PATH=$V2P_PATH/elecv2p/efss
}

docker_install
warn "小白基本回车即可，更多学习内容尽在 https://github.com/elecV2/elecV2P"

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
    echo -n -e "\e[33m\n二、请输入要创建的 Docker 容器名称[默认为：elecv2p]->\e[0m"
    read container_name
    if [ -z "$container_name" ]; then
        CONTAINER_NAME="elecv2p"
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

inp "请选择容器的网络类型：\n1) host\n2) bridge[默认]"
echo -e "\e[31m如果在部分复杂的网络情况下出现无法联网或访问的问题，尝试在命令中添加 --net=host，即选择 host 模式\e[0m\n"
opt
read net
if [ "$net" = "1" ]; then
    NETWORK="host"
    MAPPING_V2P_PORT=""
    MAPPING_HTTP_PORT=""
    MAPPING_REQUEST_PORT=""
fi

if [ "$NETWORK" = "bridge" ]; then
    inp "是否修改映射端口[默认 8100|8101|8102]：\n1) 修改\n2) 不修改[默认]"
    opt
    read change_port
    if [ "$change_port" = "1" ]; then
        echo -n -e "\e[36m输入您想修改的 webUI 端口->\e[0m"
        read V2P_PORT
        echo -n -e "\e[36m输入您想修改的代理端口->\e[0m"
        read HTTP_PORT
        echo -n -e "\e[36m输入您想修改的代理请求查看端口->\e[0m"
        read REQUEST_PORT
    fi
fi


# 配置已经创建完成，开始执行
if [ $EXT_ALL = true ]; then
    log "1.开始创建配置文件目录"
    PATH_LIST=($JSFILE_PATH $LISTS_PATH $STORE_PATH $SHELL_PATH $ROOTCA_PATH $EFSS_PATH)
    for i in ${PATH_LIST[@]}; do
        mkdir -p $i
    done
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

# 端口存在检测
check_port() {
    echo "正在检测端口:$1"
    netstat -tlpn | grep "\b$1\b"
}
if [ "$NETWORK" = "bridge" ]; then
    while check_port $V2P_PORT; do    
        echo -n -e "\e[31m端口:$V2P_PORT 被占用，请重新输入 webUI 端口：\e[0m"
        read V2P_PORT
    done
    echo -e "\e[34m恭喜，端口:$V2P_PORT 可用\e[0m"
    MAPPING_V2P_PORT="-p $V2P_PORT:80"
    while check_port $HTTP_PORT; do    
        echo -n -e "\e[31m端口:$HTTP_PORT 被占用，请重新输入代理端口：\e[0m"
        read HTTP_PORT
    done
    echo -e "\e[34m恭喜，端口:$HTTP_PORT 可用\e[0m"
    MAPPING_HTTP_PORT="-p $HTTP_PORT:8001"
    while check_port $REQUEST_PORT; do    
        echo -n -e "\e[31m端口:$REQUEST_PORT 被占用，请重新输入代理请求端口：\e[0m"
        read REQUEST_PORT
    done
    echo -e "\e[34m恭喜，端口:$REQUEST_PORT 可用\e[0m"
    MAPPING_REQUEST_PORT="-p $REQUEST_PORT:8002"
fi


log "3.开始创建容器并执行"
run_v() {
    docker run -dit \
        -t \
        -e TZ=Asia/Shanghai \
        $MAPPING_V2P_PORT \
        $MAPPING_HTTP_PORT \
        $MAPPING_REQUEST_PORT \
        -v $JSFILE_PATH:/usr/local/app/script/JSFile \
        -v $LISTS_PATH:/usr/local/app/script/Lists \
        -v $STORE_PATH:/usr/local/app/script/Store \
        -v $SHELL_PATH:/usr/local/app/script/Shell \
        -v $ROOTCA_PATH:/usr/local/app/rootCA \
        -v $EFSS_PATH:/usr/local/app/efss \
        --name $CONTAINER_NAME \
        --restart always \
        --network $NETWORK \
        $DOCKER_IMG_NAME
}
run_nov() {
    docker run -dit \
        -t \
        -e TZ=Asia/Shanghai \
        $MAPPING_V2P_PORT \
        $MAPPING_HTTP_PORT \
        $MAPPING_REQUEST_PORT \
        --name $CONTAINER_NAME \
        --restart always \
        --network $NETWORK \
        $DOCKER_IMG_NAME
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


log "enjoy!!!"

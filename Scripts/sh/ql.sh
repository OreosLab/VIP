#!/bin/sh

clear

echo -e "\e[36m
   ▄▄▄▄       ██                         ▄▄▄▄                                   
  ██▀▀██      ▀▀                         ▀▀██                                   
 ██    ██   ████     ██▄████▄   ▄███▄██    ██       ▄████▄   ██▄████▄   ▄███▄██ 
 ██    ██     ██     ██▀   ██  ██▀  ▀██    ██      ██▀  ▀██  ██▀   ██  ██▀  ▀██ 
 ██    ██     ██     ██    ██  ██    ██    ██      ██    ██  ██    ██  ██    ██ 
  ██▄▄██▀  ▄▄▄██▄▄▄  ██    ██  ▀██▄▄███    ██▄▄▄   ▀██▄▄██▀  ██    ██  ▀██▄▄███ 
   ▀▀▀██   ▀▀▀▀▀▀▀▀  ▀▀    ▀▀   ▄▀▀▀ ██     ▀▀▀▀     ▀▀▀▀    ▀▀    ▀▀   ▄▀▀▀ ██ 
       ▀                        ▀████▀▀                                 ▀████▀▀
\e[0m\n"

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
        echo     "\e[31m $1 \e[0m"
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
docker_install
warn "\n降低学习成本，小白回车到底，一路默认选择"
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
CONFIG_PATH=$JD_PATH/ql/config
DB_PATH=$JD_PATH/ql/db
REPO_PATH=$JD_PATH/ql/repo
RAW_PATH=$JD_PATH/ql/raw
SCRIPT_PATH=$JD_PATH/ql/scripts
LOG_PATH=$JD_PATH/ql/log
JBOT_PATH=$JD_PATH/ql/jbot
NINJA_PATH=$JD_PATH/ql/ninja

# 检测镜像是否存在
if [ ! -z "$(docker images -q $DOCKER_IMG_NAME:$TAG 2> /dev/null)" ]; then
    HAS_IMAGE=true
    OLD_IMAGE_ID=$(docker images -q --filter reference=$DOCKER_IMG_NAME:$TAG)
    inp "\n检测到先前已经存在的镜像，是否拉取最新的镜像：\n1) 拉取[默认]\n2) 不拉取"
    echo -n -e "\e[36m输入您的选择->\e[0m"
    read update
    if [ "$update" = "2" ]; then
        PULL_IMAGE=false
    fi
fi

# 检测容器是否存在
check_container_name() {
    if [ ! -z "$(docker ps -a | grep $CONTAINER_NAME 2> /dev/null)" ]; then
        HAS_CONTAINER=true
        inp "\n检测到先前已经存在的容器，是否删除先前的容器：\n1) 删除[默认]\n2) 不删除"
        echo -n -e "\e[36m输入您的选择->\e[0m"
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
    echo -n -e "\e[33m\n二、请输入要创建的 Docker 容器名称[默认为：qinglong]->\e[0m"
    read container_name
    if [ -z "$container_name" ]; then
        CONTAINER_NAME="qinglong"
    else
        CONTAINER_NAME=$container_name
    fi
    check_container_name
}
input_container_name

# 是否安装 WatchTower
inp "\n是否安装 containrrr/watchtower 自动更新 Docker 容器：\n1) 安装\n2) 不安装[默认]"
echo -n -e "\e[36m输入您的选择->\e[0m"
read watchtower
if [ "$watchtower" = "1" ]; then
    INSTALL_WATCH=true
fi

inp "\n请选择容器的网络类型：\n1) host[默认]\n2) bridge"
echo -n -e "\e[36m输入您的选择->\e[0m"
read net
if [ "$net" = "2" ]; then
    NETWORK="bridge"
fi

inp "\n是否在启动容器时自动启动挂机程序：\n1) 开启[默认]\n2) 关闭"
echo -n -e "\e[36m输入您的选择->\e[0m"
read hang_s
if [ "$hang_s" = "2" ]; then
    ENABLE_HANGUP_ENV=""
fi

inp "\n是否启用青龙面板：\n1) 启用[默认]\n2) 不启用"
echo -n -e "\e[36m输入您的选择->\e[0m"
read pannel
if [ "$pannel" = "2" ]; then
    ENABLE_WEB_PANNEL_ENV=""
fi

inp "\n根据设备是否映射端口：\n1) 映射[默认]\n2) 不映射"
echo -n -e "\e[36m输入您的选择->\e[0m"
read port


#配置已经创建完成，开始执行
log "\n1.开始创建配置文件目录"
PATH_LIST=($CONFIG_PATH $DB_PATH $REPO_PATH $RAW_PATH $SCRIPT_PATH $LOG_PATH $JBOT_PATH $NINJA_PATH)
for i in ${PATH_LIST[@]}; do
    mkdir -p $i
done
 
if [ $HAS_CONTAINER = true ] && [ $DEL_CONTAINER = true ]; then
    log "\n2.1.删除先前的容器"
    docker stop $CONTAINER_NAME >/dev/null
    docker rm $CONTAINER_NAME >/dev/null
fi

if [ $HAS_IMAGE = true ] && [ $PULL_IMAGE = true ]; then
    if [ ! -z "$OLD_IMAGE_ID" ] && [ $HAS_CONTAINER = true ] && [ $DEL_CONTAINER = true ]; then
        log "\n2.2.删除旧的镜像"
        docker image rm $OLD_IMAGE_ID 
    fi
    log "\n2.3.开始拉取最新的镜像"
    docker pull $DOCKER_IMG_NAME:$TAG
    if [ $? -ne 0 ] ; then
        cancelrun "** 错误: 拉取不到镜像！"
    fi
fi

log "\n3.开始创建容器并执行"

run_port(){
    docker run -dit \
        -t \
        -v $CONFIG_PATH:/ql/config \
        -v $DB_PATH:/ql/db \
        -v $LOG_PATH:/ql/log \
        -v $REPO_PATH:/ql/repo \
        -v $RAW_PATH:/ql/raw \
        -v $SCRIPT_PATH:/ql/scripts \
        -v $JBOT_PATH:/ql/jbot \
        -v $NINJA_PATH:/ql/ninja \
        -p $JD_PORT:5700 \
        -p $NINJA_PORT:5701 \
        --name $CONTAINER_NAME \
        --hostname qinglong \
        --restart always \
        $ENABLE_HANGUP_ENV \
        $ENABLE_WEB_PANEL_ENV \
        $DOCKER_IMG_NAME:$TAG
}

run_noport(){
    docker run -dit \
        -t \
        -v $CONFIG_PATH:/ql/config \
        -v $DB_PATH:/ql/db \
        -v $LOG_PATH:/ql/log \
        -v $REPO_PATH:/ql/repo \
        -v $RAW_PATH:/ql/raw \
        -v $SCRIPT_PATH:/ql/scripts \
        -v $JBOT_PATH:/ql/jbot \
        -v $NINJA_PATH:/ql/ninja \
        --name $CONTAINER_NAME \
        --hostname qinglong \
        --restart always \
        --network $NETWORK \
        $ENABLE_HANGUP_ENV \
        $ENABLE_WEB_PANEL_ENV \
        $DOCKER_IMG_NAME:$TAG
}

# 端口存在检测
check_port() {
    echo "正在检测端口 $1"
    netstat -tlpn | grep "\b$1\b"
}

while check_port $JD_PORT; do
    if [ "$port" != "2" ]; then
        echo -n -e "\e[31m端口被占用，请重新输入青龙面板端口：\e[0m"
        read JD_PORT
    else
        break
    fi 
done

while check_port $NINJA_PORT; do
    if [ "$port" != "2" ]; then
        echo -n -e "\e[31m端口被占用，请重新输入 Ninja 面板端口：\e[0m"
        read NINJA_PORT
    else
        break
    fi
done

if [ "$port" = "2" ]; then
    run_noport
else
    run_port
fi

if [ $? -ne 0 ] ; then
    cancelrun "** 错误: 容器创建失败，多数由于 docker 空间不足引起，请检查！"
fi

if [ $INSTALL_WATCH = true ]; then
    log "\n3.1.开始创建容器并执行"
    docker run -d \
    --name watchtower \
    --restart always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    containrrr/watchtower -c\
    --schedule "13,14,15 3 * * * *" \
    $CONTAINER_NAME
fi

# 检查 config 文件是否存在
if [ ! -f "$CONFIG_PATH/config.sh" ]; then
    docker cp $CONTAINER_NAME:/ql/sample/config.sample.sh $CONFIG_PATH/config.sh
    if [ $? -ne 0 ] ; then
        cancelrun "** 错误: 找不到配置文件！"
    fi
 fi

log "\n4.下面列出所有容器"
docker ps

# Nginx 静态解析检测
log "\n5.开始检测 Nginx 静态解析"
echo "开始扫描静态解析是否在线！"
ps -fe|grep nginx|grep -v grep
if [ $? -ne 0 ]; then
    echo $NOWTIME" 扫描结束！Nginx 静态解析停止！准备重启！"
    docker exec -it $CONTAINER_NAME nginx -c /etc/nginx/nginx.conf
    echo $NOWTIME" Nginx 静态解析重启完成！"
else
    echo $NOWTIME" 扫描结束！Nginx 静态解析正常！"
fi

if [ "$port" = "2" ]; then
    log "\n6.安装已完成，请自行调整端口映射并进入面板一次以便进行内部配置"
else
    log "\n6.安装已完成，请进入面板一次以便进行内部配置"
    log "\n6.1.用户名和密码已显示，请登录 ip:5700"
    cat $CONFIG_PATH/auth.json    
fi

# 防止 CPU 占用过高导致死机
echo -e "\n---------- 机器累了，休息 20s，趁机去操作一下吧 ----------"
sleep 20

# 显示 auth.json
inp "\n是否显示被修改的密码：\n1) 显示[默认]\n2) 不显示"
echo -n -e "\e[36m输入您的选择->\e[0m"
read display
if [ "$display" != "2" ]; then
    cat $CONFIG_PATH/auth.json
    log "\n6.2.用被修改的密码登录面板并进入"
fi  

# token 检测
inp "\n是否已进入面板：\n1) 进入[默认]\n2) 未进入"
echo -n -e "\e[36m输入您的选择->\e[0m"
read access
log "\n6.3.观察 token 是否成功生成"
cat $CONFIG_PATH/auth.json
if [ "$access" != "2" ]; then
    if [ "$(grep -c "token" $CONFIG_PATH/auth.json)" != 0 ]; then
        log "\n7.开始青龙内部配置"
        docker exec -it $CONTAINER_NAME bash -c "$(curl -fsSL https://gitee.com/allin1code/a1/raw/master/1customCDN.sh)"
    else
        warn "\n7.未检测到 token，取消内部配置"
    fi
else
    exit 0
fi

log "全面部署已完成！enjoy!!!"
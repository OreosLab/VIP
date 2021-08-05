#!/bin/sh

# source: https://github.com/Annyoo2021/jd_v4_bot

clear

echo "

     ██╗██████╗     ██████╗  ██████╗  ██████╗██╗  ██╗███████╗██████╗     ██╗   ██╗██╗  ██╗
     ██║██╔══██╗    ██╔══██╗██╔═══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗    ██║   ██║██║  ██║
     ██║██║  ██║    ██║  ██║██║   ██║██║     █████╔╝ █████╗  ██████╔╝    ██║   ██║███████║
██   ██║██║  ██║    ██║  ██║██║   ██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗    ╚██╗ ██╔╝╚════██║
╚█████╔╝██████╔╝    ██████╔╝╚██████╔╝╚██████╗██║  ██╗███████╗██║  ██║     ╚████╔╝      ██║
 ╚════╝ ╚═════╝     ╚═════╝  ╚═════╝  ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝      ╚═══╝       ╚═╝

"

DOCKER_IMG_NAME="annyooo/jd"
JD_PATH=""
SHELL_FOLDER=$(pwd)
CONTAINER_NAME=""
CONFIG_PATH=""
LOG_PATH=""
TAG="v4_bot"
NETWORK="host"
JD_PORT=5678

HAS_IMAGE=false
EXT_SCRIPT=true
PULL_IMAGE=true
HAS_CONTAINER=false
DEL_CONTAINER=true
INSTALL_WATCH=false
TEST_BEAN_CHAGE=false
ENABLE_WEB_PANEL=true
ENABLE_HANGUP=true
OLD_IMAGE_ID=""
MOUNT_SCRIPT=""
MAPPING_PORT="-p $JD_PORT:5678"
CHANGE_NETWORK="--network $NETWORK"
ENABLE_HANGUP_ENV="--env ENABLE_HANGUP=true"
ENABLE_BOT_ENV="--env ENABLE_TG_BOT=true"
ENABLE_WEB_PANEL_ENV="--env ENABLE_WEB_PANEL=true"


log() {
    echo -e "\e[32m\n$1 \e[0m\n"
}

inp() {
    echo -e "\e[33m\n$1 \e[0m\n"
}

warn() {
    echo -e "\e[31m\n$1 \e[0m\n"
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

docker_install
warn "一路有我，回车即可，小白福音！！！这是 TG BOT 版！！！"
# 配置文件保存目录
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
CONFIG_PATH=$JD_PATH/jd_v4_bot/config
LOG_PATH=$JD_PATH/jd_v4_bot/log
OWN_PATH=$JD_PATH/jd_v4_bot/own
SCRIPT_PATH=$JD_PATH/jd_v4_bot/scripts
DIY_PATH=$JD_PATH/jd_v4_bot/diy

inp "是否为 arm64 架构：\n1) x86[默认]\n2) arm64"
echo -n -e "\e[36m输入您的选择->\e[0m"
read Processor_architecture
if [ "$Processor_architecture" = "2" ]; then
    TAG="v4_bot_arm64"
fi

inp "是否将 scripts 目录映射到外部：\n1) 映射[默认]\n2) 不映射"
echo -n -e "\e[36m输入您的选择->\e[0m"
read ext_s
if [ "$ext_s" = "2" ]; then
    EXT_SCRIPT=false
fi

# 检测镜像是否存在
if [ ! -z "$(docker images -q $DOCKER_IMG_NAME:$TAG 2> /dev/null)" ]; then
    HAS_IMAGE=true
    OLD_IMAGE_ID=$(docker images -q --filter reference=$DOCKER_IMG_NAME:$TAG)
    inp "检测到先前已经存在的镜像，是否拉取最新的镜像：\n1) 拉取[默认]\n2) 不拉取"
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
        inp "检测到先前已经存在的容器，是否删除先前的容器：\n1) 删除[默认]\n2) 不删除"
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
    echo -n -e "\e[33m\n二、请输入要创建的 Docker 容器名称[默认为：jd_v4_bot]->\e[0m"
    read container_name
    if [ -z "$container_name" ]; then
        CONTAINER_NAME="jd_v4_bot"
    else
        CONTAINER_NAME=$container_name
    fi
    check_container_name
}
input_container_name

# 是否安装WatchTower
inp "是否安装 containrrr/watchtower 自动更新 Docker 容器：\n1) 安装\n2) 不安装[默认]"
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

inp "是否启用 TG BOT：\n1) 启用[默认]\n2) 不启用"
echo -n -e "\e[36m输入您的选择->\e[0m"
read bot
if [ "$bot" = "2" ]; then
    ENABLE_BOT_ENV=""
fi

inp "是否启用 V4 面板：\n1) 启用[默认]\n2) 不启用"
echo -n -e "\e[36m输入您的选择->\e[0m"
read pannel
if [ "$pannel" = "2" ]; then
    ENABLE_WEB_PANNEL_ENV=""
fi

inp "根据设备是否映射端口：\n1) 映射[默认]\n2) 不映射"
echo -n -e "\e[36m输入您的选择->\e[0m"
read port
if [ "$port" = "2" ]; then
    MAPPING_PORT=""
else 
    CHANGE_NETWORK=""
fi

if [ "$port" != "2" ]; then
    inp "是否修改端口：\n1) 修改\n2) 不修改[默认]"
    echo -n -e "\e[36m输入您的选择->\e[0m"
    read change_port
    if [ "$change_port" = "1" ]; then
        echo -n -e "\e[36m输入您想修改的端口->\e[0m"
        read JD_PORT
        MAPPING_PORT="-p $JD_PORT:5678"
    fi
fi

# 配置已经创建完成，开始执行
log "1.开始创建配置文件目录"
mkdir -p $CONFIG_PATH
mkdir -p $LOG_PATH
mkdir -p $OWN_PATH
mkdir -p $DIY_PATH
if [ $EXT_SCRIPT = true ]; then
    mkdir -p $SCRIPT_PATH
fi

if [ $? -ne 0 ] ; then
    cancelrun "** 错误：目录创建错误请重试！"
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

if [ $EXT_SCRIPT = true ]; then
    MOUNT_SCRIPT="-v $SCRIPT_PATH:/jd/scripts"
fi

# 端口存在检测
check_port() {
    echo "正在检测端口 $1"
    netstat -tlpn | grep "\b$1\b"
}
while check_port $JD_PORT; do
    if [ "$port" != "2" ]; then
        echo -n -e "\e[31m端口被占用，请重新输入 V4 面板端口：\e[0m"
        read JD_PORT
    else
        break
        MAPPING_PORT="-p $JD_PORT:5678"
    fi 
done

log "3.开始创建容器并执行"
docker run -dit \
    -t \
    -v $CONFIG_PATH:/jd/config \
    -v $LOG_PATH:/jd/log \
    -v $OWN_PATH:/jd/own \
    -v $SCRIPT_PATH:/jd/scripts \
    -v $DIY_PATH:/jd/jbot/diy \
    $MOUNT_SCRIPT \
    $MAPPING_PORT \
    --name $CONTAINER_NAME \
    --hostname jd_v4_bot \
    --restart always \
    $CHANGE_NETWORK \
    $ENABLE_HANGUP_ENV \
    $ENABLE_BOT_ENV \
    $ENABLE_WEB_PANEL_ENV \
    $DOCKER_IMG_NAME:$TAG

if [ $? -ne 0 ] ; then
    cancelrun "** 错误：容器创建失败，多数由于 docker 空间不足引起，请检查！"
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

# 检查config文件是否存在
if [ ! -f "$CONFIG_PATH/config.sh" ]; then
    docker cp $CONTAINER_NAME:/jd/sample/config.sample.sh $CONFIG_PATH/config.sh
    if [ $? -ne 0 ] ; then
        cancelrun "** 错误：找不到配置文件！"
    fi
 fi

log "4.下面列出所有容器"
docker ps

if [ "$pannel" != "2" ]; then
    log "5.开始安装面板"
    docker exec $CONTAINER_NAME bash -c "$(curl -fsSL https://raw.githubusercontent.com/Annyoo2021/jd_v4_bot/main/v4mb.sh)"
fi

log "6.安装已经完成。创建好后请阅读映射的 config 目录下的的 config.sh，并根据注释修改。"
log "7.如果启用了 ENABLE_TG_BOT，创建好后请阅读映射的 config 目录下的的 config.sh 和 bot.json，并根据说明修改，首次创建并不会启动 bot，修改好 bot.json 后请重启容器。"
log "命令提示：\njtask mtask otask 链接的都是同一个脚本，m=my，o=own，j=jd。三者区分仅用在 crontab.list 中，以区别不同类型任务，手动运行直接 jtask 即可。\ndocker exec $CONTAINER_NAME jtask   # 运行 scripts 脚本\ndocker exec $CONTAINER_NAME otask   # 运行 own 脚本\ndocker exec $CONTAINER_NAME mtask   # 运行你自己的脚本，如果某些 own 脚本识别不出来 cron，你也可以自行添加 mtask 任务\ndocker exec $CONTAINER_NAME jlog    # 删除旧日志\ndocker exec $CONTAINER_NAME jup     # 更新所有脚本\ndocker exec $CONTAINER_NAME jcode   # 导出所有互助码\ndocker exec $CONTAINER_NAME jcsv    # 记录豆豆变化情况"
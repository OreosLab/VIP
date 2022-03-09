#!/usr/bin/env bash
# shellcheck disable=SC2181

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
TAG="v4_bot"
NETWORK="bridge"
JD_PORT=5678

HAS_IMAGE=false
EXT_SCRIPT=true
PULL_IMAGE=true
HAS_CONTAINER=false
DEL_CONTAINER=true
INSTALL_WATCH=false
ENABLE_HANGUP=true
ENABLE_TG_BOT=true
ENABLE_WEB_PANEL=true
OLD_IMAGE_ID=""
MOUNT_SCRIPT=""

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
        if [ "$lsb_dist" == "openwrt" ]; then
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
echo -n -e "\e[33m一、请输入配置文件保存的绝对路径（示例：/root)，回车默认为当前目录:\e[0m"
read -r jd_path
if [ -z "$jd_path" ]; then
    JD_PATH=$SHELL_FOLDER
elif [ -d "$jd_path" ]; then
    JD_PATH=$jd_path
else
    mkdir -p "$jd_path"
    JD_PATH=$jd_path
fi
CONFIG_PATH=$JD_PATH/v4/config
LOG_PATH=$JD_PATH/v4/log
OWN_PATH=$JD_PATH/v4/own
SCRIPT_PATH=$JD_PATH/v4/scripts
DIY_PATH=$JD_PATH/v4/diy

inp "选择你想拉取的 V4 镜像：\n1) annyooo/jd:v4_bot[默认]\n2) jiulan/jd:test（备份 nevinee/jd:v4）\n3) jiulan/jd:v4\n4) jiulan/jd:v4_arm64\n5) annyooo/jd:v4_bot_arm64"
opt
read -r image
image=${image:-'1'}
if [ "$image" = "2" ]; then
    DOCKER_IMG_NAME="jiulan/jd"
    TAG="test"
elif [ "$image" = "3" ]; then
    DOCKER_IMG_NAME="jiulan/jd"
    TAG="v4"
elif [ "$image" = "4" ]; then
    DOCKER_IMG_NAME="jiulan/jd"
    TAG="v4_arm64"
elif [ "$image" = "5" ]; then
    TAG="v4_bot_arm64"
fi

inp "是否将 scripts 目录映射到外部：\n1) 映射[默认]\n2) 不映射"
opt
read -r ext_s
if [ "$ext_s" = "2" ]; then
    EXT_SCRIPT=false
fi

# 检测镜像是否存在
if [ -n "$(docker images -q $DOCKER_IMG_NAME:$TAG 2>/dev/null)" ]; then
    HAS_IMAGE=true
    OLD_IMAGE_ID=$(docker images -q --filter reference=$DOCKER_IMG_NAME:$TAG)
    inp "检测到先前已经存在的镜像，是否拉取最新的镜像：\n1) 拉取[默认]\n2) 不拉取"
    opt
    read -r update
    if [ "$update" = "2" ]; then
        PULL_IMAGE=false
    fi
fi

# 检测容器是否存在
check_container_name() {
    if docker ps -a | grep "$CONTAINER_NAME" 2>/dev/null; then
        HAS_CONTAINER=true
        inp "检测到先前已经存在的容器，是否删除先前的容器：\n1) 删除[默认]\n2) 不删除"
        opt
        read -r update
        if [ "$update" = "2" ]; then
            PULL_IMAGE=false
            inp "您选择了不删除之前的容器，需要重新输入容器名称"
            input_container_name
        fi
    fi
}

# 容器名称
input_container_name() {
    echo -n -e "\e[33m\n二、请输入要创建的 Docker 容器名称[默认为：v4]->\e[0m"
    read -r container_name
    if [ -z "$container_name" ]; then
        CONTAINER_NAME="v4"
    else
        CONTAINER_NAME=$container_name
    fi
    check_container_name
}
input_container_name

# 是否安装 WatchTower
inp "是否安装 containrrr/watchtower 自动更新 Docker 容器：\n1) 安装\n2) 不安装[默认]"
opt
read -r watchtower
if [ "$watchtower" = "1" ]; then
    INSTALL_WATCH=true
fi

inp "请选择容器的网络类型：\n1) host\n2) bridge[默认]"
opt
read -r net
if [ "$net" = "1" ]; then
    NETWORK="host"
    MAPPING_JD_PORT=""
fi

inp "是否在启动容器时自动启动挂机程序：\n1) 开启[默认]\n2) 关闭"
opt
read -r hang_s
if [ "$hang_s" = "2" ]; then
    ENABLE_HANGUP=false
fi

inp "是否启用 TG BOT：\n1) 启用[默认]\n2) 不启用"
opt
read -r bot
if [ "$bot" = "2" ]; then
    ENABLE_TG_BOT=false
fi

inp "是否启用 V4 面板：\n1) 启用[默认]\n2) 不启用"
opt
read -r panel
if [ "$panel" = "2" ]; then
    ENABLE_WEB_PANEL=false
fi

# 端口问题
modify_v4_port() {
    inp "是否修改 V4 端口[默认 5678]：\n1) 修改\n2) 不修改[默认]"
    opt
    read -r change_port
    if [ "$change_port" = "1" ]; then
        echo -n -e "\e[36m输入您想修改的端口->\e[0m"
        read -r JD_PORT
    fi
}
if [ "$NETWORK" = "bridge" ]; then
    inp "是否映射端口：\n1) 映射[默认]\n2) 不映射"
    opt
    read -r port
    if [ "$port" = "2" ]; then
        MAPPING_JD_PORT=""
    else
        modify_v4_port
    fi
fi

# 配置已经创建完成，开始执行
log "1.开始创建配置文件目录"
mkdir -p "$CONFIG_PATH"
mkdir -p "$LOG_PATH"
mkdir -p "$OWN_PATH"
mkdir -p "$DIY_PATH"
if [ $EXT_SCRIPT = true ]; then
    mkdir -p "$SCRIPT_PATH"
fi

if [ $? -ne 0 ]; then
    cancelrun "** 错误：目录创建错误请重试！"
fi

if [ $HAS_CONTAINER = true ] && [ $DEL_CONTAINER = true ]; then
    log "2.1.删除先前的容器"
    docker stop "$CONTAINER_NAME" >/dev/null
    docker rm "$CONTAINER_NAME" >/dev/null
fi

if [ $HAS_IMAGE = true ] && [ $PULL_IMAGE = true ]; then
    if [ -n "$OLD_IMAGE_ID" ] && [ $HAS_CONTAINER = true ] && [ $DEL_CONTAINER = true ]; then
        log "2.2.删除旧的镜像"
        docker image rm "$OLD_IMAGE_ID"
    fi
    log "2.3.开始拉取最新的镜像"
    docker pull $DOCKER_IMG_NAME:$TAG
    if [ $? -ne 0 ]; then
        cancelrun "** 错误：拉取不到镜像！"
    fi
fi

if [ $EXT_SCRIPT = true ]; then
    MOUNT_SCRIPT="-v $SCRIPT_PATH:/jd/scripts"
fi

# 端口存在检测
check_port() {
    echo "正在检测端口:$1"
    netstat -tlpn | grep "[[:graph:]]*:${1}\b"
}
if [ "$port" != "2" ]; then
    while check_port "$JD_PORT"; do
        echo -n -e "\e[31m端口:$JD_PORT 被占用，请重新输入 V4 面板端口：\e[0m"
        read -r JD_PORT
    done
    echo -e "\e[34m恭喜，端口:$JD_PORT 可用\e[0m"
    MAPPING_JD_PORT="-p $JD_PORT:5678"
fi

log "3.开始创建容器并执行"
# shellcheck disable=SC2086
docker run -dit \
    -t \
    -v "$CONFIG_PATH":/jd/config \
    -v "$LOG_PATH":/jd/log \
    -v "$OWN_PATH":/jd/own \
    $MOUNT_SCRIPT \
    -v "$DIY_PATH":/jd/jbot/diy \
    $MAPPING_JD_PORT \
    --name "$CONTAINER_NAME" \
    --hostname v4 \
    --restart always \
    --network $NETWORK \
    --env ENABLE_HANGUP=$ENABLE_HANGUP \
    --env ENABLE_TG_BOT=$ENABLE_TG_BOT \
    --env ENABLE_WEB_PANEL=$ENABLE_WEB_PANEL \
    $DOCKER_IMG_NAME:$TAG

if [ $? -ne 0 ]; then
    cancelrun "** 错误：容器创建失败，请翻译以上英文报错，Google/百度尝试解决问题！"
fi

if [ $INSTALL_WATCH = true ]; then
    log "3.1.开始创建容器并执行"
    docker run -d \
        --name watchtower \
        --restart always \
        -v /var/run/docker.sock:/var/run/docker.sock \
        containrrr/watchtower -c --schedule "13,14,15 3 * * * *" \
        "$CONTAINER_NAME"
fi

# 检查 config 文件是否存在
if [ ! -f "$CONFIG_PATH/config.sh" ]; then
    docker cp "$CONTAINER_NAME":/jd/sample/config.sample.sh "$CONFIG_PATH"/config.sh
    if [ $? -ne 0 ]; then
        cancelrun "** 错误：找不到配置文件！"
    fi
fi

log "4.下面列出所有容器"
docker ps

if [ "$panel" != "2" ]; then
    log "5.开始安装面板"
    if [ "$image" = "1" ] || [ "$image" = "5" ]; then
        url="https://raw.githubusercontents.com/Annyoo2021/jd_v4_bot/main/v4mb.sh"
    else
        url="https://raw.githubusercontents.com/jiulan/jd_v4/main/v4mb.sh"
    fi
    docker exec "$CONTAINER_NAME" bash -c "$(curl -fsSL $url)"
fi

log "6.安装已经完成。创建好后请阅读映射的 config 目录下的的 config.sh，并根据注释修改。"
log "7.如果启用了 ENABLE_TG_BOT，创建好后请阅读映射的 config 目录下的的 config.sh 和 bot.json，并根据说明修改，首次创建并不会启动 bot，修改好 bot.json 后请重启容器。"
log "命令提示：\njtask mtask otask 链接的都是同一个脚本，m=my，o=own，j=jd。三者区分仅用在 crontab.list 中，以区别不同类型任务，手动运行直接 jtask 即可。\ndocker exec $CONTAINER_NAME jtask   # 运行 scripts 脚本\ndocker exec $CONTAINER_NAME otask   # 运行 own 脚本\ndocker exec $CONTAINER_NAME mtask   # 运行你自己的脚本，如果某些 own 脚本识别不出来 cron，你也可以自行添加 mtask 任务\ndocker exec $CONTAINER_NAME jlog    # 删除旧日志\ndocker exec $CONTAINER_NAME jup     # 更新所有脚本\ndocker exec $CONTAINER_NAME jcode   # 导出所有互助码\ndocker exec $CONTAINER_NAME jcsv    # 记录豆豆变化情况"

log "enjoy!!!"

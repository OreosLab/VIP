#!/usr/bin/env bash
# shellcheck disable=SC2015
# 自定义字体彩色函数、read 函数
red() { echo -e "\033[31m\033[01m$1\033[0m"; }
green() { echo -e "\033[32m\033[01m$1\033[0m"; }
yellow() { echo -e "\033[33m\033[01m$1\033[0m"; }
reading() { read -rp "$(green "$1")" "$2"; }

# 操作系统及其包管理工具判断函数
check_sys() {
    CMD=(
        "$(grep -i pretty_name /etc/os-release 2>/dev/null | cut -d \" -f2)"
        "$(hostnamectl 2>/dev/null | grep -i system | cut -d : -f2)"
        "$(lsb_release -sd 2>/dev/null)"
        "$(grep -i description /etc/lsb-release 2>/dev/null | cut -d \" -f2)"
        "$(grep . /etc/redhat-release 2>/dev/null)"
        "$(grep . /etc/issue 2>/dev/null | cut -d \\ -f1 | sed '/^[ ]*$/d')"
    )

    for i in "${CMD[@]}"; do
        sys="$i" && [[ -n $sys ]] && break
    done

    REGEX=("debian" "ubuntu" "centos|red hat|kernel|oracle linux|alma|rocky" "'amazon linux'")
    RELEASE=("Debian" "Ubuntu" "CentOS" "CentOS")
    PKG_TOOL=("apt -y" "apt -y" "yum -y" "yum -y")

    for ((j = 0; j < ${#REGEX[@]}; j++)); do
        echo "$sys" | grep -Eiq "${REGEX[j]}" && system="${RELEASE[j]}" && PKG="${PKG_TOOL[j]}" && [[ -n $system ]] && break
    done
    [[ -z $system ]] && red "本脚本只支持 Debian、Ubuntu、CentOS 系统" && exit 1
}

install_lolcat() {
    ${PKG} update && ${PKG} install curl wget sudo && ${PKG} install ruby
    gem install lolcat
}

egg=(
    "boxes"
    "sl"
    "toilet"
    "figlet"
)

egg_pkg=(
    "boxes"
    "sl"
    "toilet"
    "figlet"
)

egg_tip=(
    "ASCII艺术框"
    "火车：Strem Locomotive"
    "艺术字生成器"
    "艺术字生成器"
)

choose_egg() {
    yellow "选择安装 40 个有趣的 Linux 命令行彩蛋或游戏"
    for ((i = 0; i < ${#egg[*]}; i++)); do
        printf "%s.%-15s %-15s\n" "$((i + 1))" "${egg[i]}" "${egg_tip[i]}" | lolcat
    done
    reading "请输入你要安装的彩蛋编号，用空格隔开；或输入 A 进行全部安装: " opt
}

install_egg() {
    echo -e "开始安装 $1..." | lolcat
    ${PKG} install "$2"
    [[ -n $(which "$1") ]] && green "$1 安装成功！" || red "$1 安装失败！"
}

# shellcheck disable=SC2154
install_egg_all() {
    if [[ $opt =~ "A" ]]; then
        for ((j = 0; j < ${#egg_pkg[*]}; j++)); do
            install_egg "${egg[j]}" "${egg_pkg[j]}"
        done
    else
        for k in $opt; do
            m=$((k - 1))
            install_egg "${egg[m]}" "${egg_pkg[m]}"
        done
    fi
}

check_sys
install_lolcat
choose_egg
install_egg_all

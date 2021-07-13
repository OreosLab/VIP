#!/usr/bin/env bash

## 本脚本搬运并模仿 jdshell 仓库
dir_shell=/ql/config
dir_script=/ql/config
config_shell_path=$dir_shell/config.sh
extra_shell_path=$dir_script/extra.sh
code_shell_path=$dir_script/code.sh
task_before_shell_path=$dir_shell/task_before.sh


# 下载 config.sh
if [ ! -a "$config_shell_path" ]; then
    touch $config_shell_path
fi
curl -s --connect-timeout 5 https://git.io/config.sh > $config_shell_path
cp $config_shell_path $dir_shell/config.sh

# 判断是否下载成功
config_size=$(ls -l $config_shell_path | awk '{print $5}')
if (( $(echo "${config_size} < 100" | bc -l) )); then
    echo "config.sh 下载失败"
    exit 0
fi


# 下载 extra.sh
if [ ! -a "$extra_shell_path" ]; then
    touch $extra_shell_path
fi
curl -s --connect-timeout 3 https://raw.githubusercontent.com/Oreomeow/VIP/main/Tasks/qlrepo/extra.sh > $extra_shell_path
cp $extra_shell_path $dir_shell/extra.sh

# 判断是否下载成功
extra_size=$(ls -l $extra_shell_path | awk '{print $5}')
if (( $(echo "${extra_size} < 100" | bc -l) )); then
    echo "extra.sh 下载失败"
    exit 0
fi

# 授权
chmod 755 $extra_shell_path

# 将 extra.sh 添加到定时任务
if [ "$(grep -c extra.sh /ql/config/crontab.list)" = 0 ]; then
    echo "开始添加 task extra.sh"
    # 获取token
    token=$(cat /ql/config/auth.json | jq --raw-output .token)
    curl -s -H 'Accept: application/json' -H "Authorization: Bearer $token" -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept-Language: zh-CN,zh;q=0.9' --data-binary '{"name":"初始化任务","command":"ql extra","schedule":"15 0-23/4 * * *"}' --compressed 'http://127.0.0.1:5700/api/crons?t=1624782068473'
fi


# 下载 code.sh
if [ ! -a "$code_shell_path" ]; then
    touch $code_shell_path
fi
curl -s --connect-timeout 3 https://raw.githubusercontent.com/Oreomeow/VIP/main/Scripts/sh/Helpcode2.8/code.sh > $code_shell_path
cp $code_shell_path $dir_shell/code.sh

# 判断是否下载成功
code_size=$(ls -l $code_shell_path | awk '{print $5}')
if (( $(echo "${code_size} < 100" | bc -l) )); then
    echo "code.sh 下载失败"
    exit 0
fi

# 授权
chmod 755 $code_shell_path

# 将 code.sh 添加到定时任务
if [ "$(grep -c code.sh /ql/config/crontab.list)" = 0 ]; then
    echo "开始添加 task code.sh"
    # 获取token
    token=$(cat /ql/config/auth.json | jq --raw-output .token)
    curl -s -H 'Accept: application/json' -H "Authorization: Bearer $token" -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept-Language: zh-CN,zh;q=0.9' --data-binary '{"name":"格式化更新助力码","command":"bash /ql/config/code.sh &","schedule":"*/10 * * * *"}' --compressed 'http://127.0.0.1:5700/api/crons?t=1624782068473'
fi


# 下载 task_before.sh
curl -s --connect-timeout 3 https://raw.githubusercontent.com/Oreomeow/VIP/main/Scripts/sh/Helpcode2.8/task_before.sh > $task_before_shell_path

# 判断是否下载成功
task_before_size=$(ls -l $task_before_shell_path | awk '{print $5}')
if (( $(echo "${task_before_size} < 100" | bc -l) )); then
    echo "task_before.sh 下载失败"
    exit 0
fi
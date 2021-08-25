#!/usr/bin/env bash

## 本脚本搬运并模仿 liuqitoday
dir_config=/ql/config
dir_script=/ql/scripts
dir_repo=/ql/repo
config_shell_path=$dir_config/config.sh
extra_shell_path=$dir_config/extra.sh
code_shell_path=$dir_config/code.sh
task_before_shell_path=$dir_config/task_before.sh
bot_json=$dir_config/bot.json


# 控制是否执行变量
read -p "是否执行全部操作，输入 1 即可执行全部，输入 0 则跳出，回车默认和其他可进行选择性操作，建议初次配置输入 1：" all
if [ "${all}" = 1 ]; then
    echo "将执行全部操作"
elif [ "${all}" = 0 ]; then
    exit 0
else
    read -p "config.sh 操作（替换或下载选项为 y，不替换为 n，回车为替换）请输入：" Rconfig
    Rconfig=${Rconfig:-'y'}
    read -p "extra.sh 操作（替换或下载选项为 a，修改设置区设置为 b，添加到定时任务为 c，立即执行一次为 d，全部不执行为 n，回车全部执行 | 示例：acd）请输入：" extra
    extra=${extra:-'abcd'}
    read -p "code.sh 操作（替换或下载选项为 a，修改默认调用日志设置为 b，添加到定时任务为 c，全部不执行为 n，回车全部执行 | 示例：ac）请输入：" code
    code=${code:-'abcd'}
    read -p "task_before.sh 操作（替换或下载选项为 y，不替换为 n，回车为替换）请输入：" Rbefore
    Rbefore=${Rbefore:-'y'}
    read -p "bot 操作（跳过为 0，添加 task:ql bot 选项为 1，添加后设置并运行为 2，回车等同 1）请输入:" bot
    bot=${bot:-'1'}
    read -p "config.sample.sh 操作（跳过为 0，添加 task:自动更新模板 选项为 1，添加后运行一次为 2，回车等同 2）请输入：" sample
    sample=${sample:-'2'}
fi


# 下载 config.sh
dl_config_shell() {
    if [ ! -a "$config_shell_path" ]; then
        touch $config_shell_path
    fi
    curl -s --connect-timeout 3 https://raw.githubusercontent.com/Oreomeow/VIP/main/Conf/Qinglong/config.sample.sh > $config_shell_path
    cp $config_shell_path $dir_config/config.sh
    # 判断是否下载成功
    config_size=$(ls -l $config_shell_path | awk '{print $5}')
    if (( $(echo "${config_size} < 100" | bc -l) )); then
        echo "config.sh 下载失败"
        exit 0
    fi
}
if [ "${Rconfig}" = 'y' -o "${all}" = 1 ]; then
    dl_config_shell
else
    echo "已为您跳过替换 config.sh"
fi


# 下载 extra.sh
dl_extra_shell() {
    if [ ! -a "$extra_shell_path" ]; then
        touch $extra_shell_path
    fi
    curl -s --connect-timeout 3 https://raw.githubusercontent.com/Oreomeow/VIP/main/Tasks/qlrepo/extra.sh > $extra_shell_path
    cp $extra_shell_path $dir_config/extra.sh
    # 判断是否下载成功
    extra_size=$(ls -l $extra_shell_path | awk '{print $5}')
    if (( $(echo "${extra_size} < 100" | bc -l) )); then
        echo "extra.sh 下载失败"
        exit 0
    fi
    # 授权
    chmod 755 $extra_shell_path
}
# extra.sh 预设仓库及默认拉取仓库设置
set_default_extra() {   
    echo -e "一、集成仓库（Collected Repositories)\n2-JDHelloWorld\n3-he1pu\n4-shufflewzc\n6-Aaron-lv\n7-yuannian1112"
    read -p "输入您想拉取集成仓库编号(回车默认为 4)，拉取多个请用空格隔开:" CollectedRepo
    echo -e "二、其他仓库（Other Repositories）\n1-passerby-b\n2-curtinlv\n3-smiek2221\n4-cdle\n5-ZCY01\n6-whyour/hundun\n7-moposmall\n8-Ariszy (Zhiyi-N)\n9-photonmang\n10-jiulan\n12-star261\n13-Wenmoux\n14-Tsukasa007"
    read -p "输入您想拉取其他仓库编号(回车默认不拉取)，拉取多个请用空格隔开:" OtherRepo 
    CollectedRepo=${CollectedRepo:-"4"}
    sed -i "s/CollectedRepo=(4)/CollectedRepo=(${CollectedRepo})/g" $extra_shell_path
    sed -i "s/OtherRepo=()/OtherRepo=(${OtherRepo})/g" $extra_shell_path
    echo -e "Ninja\n###（1）默认启动并自动更新\n###（2）！！！未修改容器映射的请勿运行，否则会出现青龙打不开或者设备死机等不良后果，映射参考 https://github.com/MoonBegonia/ninja#%E5%AE%B9%E5%99%A8%E5%86%85"
    read -p "Ninja="on" ##up为更新，on为启动，down为不运行，请输入您的设置（默认运行） up/on/down：" Ninja
    sed -i "s/Ninja=\"on\"/Ninja=\"${Ninja}\"/" $extra_shell_path
}
# 将 ql extra 添加到定时任务
add_ql_extra() {
    if [ "$(grep -c "ql\ extra" /ql/config/crontab.list)" != 0 ]; then
        echo "您的任务列表中已存在 task:ql extra"
    else
        echo "开始添加 task:ql extra"
        # 获取token
        token=$(cat /ql/config/auth.json | jq --raw-output .token)
        curl -s -H 'Accept: application/json' -H "Authorization: Bearer $token" -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept-Language: zh-CN,zh;q=0.9' --data-binary '{"name":"初始化任务","command":"ql extra","schedule":"15 0-23/4 * * *"}' --compressed 'http://127.0.0.1:5700/api/crons?t=1624782068473'
    fi
}
# 运行一次 ql extra
run_ql_extra() {
    ql extra
    sleep 5
}
if [ "${all}" = 1 ]; then
    dl_extra_shell && set_default_extra && add_ql_extra && run_ql_extra
elif [ "${extra}" = 'n' ]; then
    echo "已为您跳过操作 extra.sh"
else
    if [[ ${extra} =~ 'a' ]]; then
        dl_extra_shell
    fi
    if [[ ${extra} =~ 'b' ]]; then
        set_default_extra
    fi
    if [[ ${extra} =~ 'c' ]]; then
        add_ql_extra
    fi
    if [[ ${extra} =~ 'd' ]]; then
        run_ql_extra
    fi
fi


# 下载 code.sh
dl_code_shell() {
    if [ ! -a "$code_shell_path" ]; then
        touch $code_shell_path
    fi
    curl -s --connect-timeout 3 https://raw.githubusercontent.com/Oreomeow/VIP/main/Scripts/sh/Helpcode2.8/code.sh > $code_shell_path
    cp $code_shell_path $dir_config/code.sh
    # 判断是否下载成功
    code_size=$(ls -l $code_shell_path | awk '{print $5}')
    if (( $(echo "${code_size} < 100" | bc -l) )); then
        echo "code.sh 下载失败"
        exit 0
    fi
    # 授权
    chmod 755 $code_shell_path
}
# code.sh 预设仓库及默认调用仓库设置
set_default_code() {
    echo -e "## 将\"repo=\$repo1\"改成\"repo=\$repo2\"或其他，以默认调用其他仓库脚本日志\nrepo1='panghu999_jd_scripts' #预设的 panghu999 仓库\nrepo2='JDHelloWorld_jd_scripts' #预设的 JDHelloWorld 仓库\nrepo3='he1pu_JDHelp' #预设的 he1pu 仓库\nrepo4='shufflewzc_faker2' #预设的 shufflewzc 仓库\nrepo6='Aaron-lv_sync_jd_scripts' #预设的 Aaron-lv 仓库\nrepoA='yuannian1112_jd_scripts' #预设的 yuannian1112 仓库\nrepo=\$repo1 #默认调用 panghu999 仓库脚本日志"
    read -p "输入您想调用的仓库编号(默认为 4):" repoNum
    repoNum=${repoNum:-'4'}
    sed -i "s/repo=\$repo[0-9]/repo=\$repo${repoNum}/g" $code_shell_path
    if [ "${repoNum}" = 'A' ]; then
        sed -i "/^repo7=/a\repoA='yuannian1112_jd_scripts'" $code_shell_path
    fi
}
# 将 task code.sh 添加到定时任务
add_task_code() {
    if [ "$(grep -c "code.sh" /ql/config/crontab.list)" != 0 ]; then
        echo "您的任务列表中已存在 task:task code.sh"
    else
        echo "开始添加 task:task code.sh"
        # 获取token
        token=$(cat /ql/config/auth.json | jq --raw-output .token)
        curl -s -H 'Accept: application/json' -H "Authorization: Bearer $token" -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept-Language: zh-CN,zh;q=0.9' --data-binary '{"name":"格式化更新助力码","command":"task /ql/config/code.sh","schedule":"*/10 * * * *"}' --compressed 'http://127.0.0.1:5700/api/crons?t=1626247939659'
    fi
}
if [ "${all}" = 1 ]; then
    dl_code_shell && set_default_code && add_task_code
elif [ "${code}" = 'n' ]; then
    echo "已为您跳过操作 code.sh"
else
    if [[ ${code} =~ 'a' ]]; then
        dl_code_shell
    fi
    if [[ ${code} =~ 'b' ]]; then
        set_default_code
    fi
    if [[ ${code} =~ 'c' ]]; then
        add_task_code
    fi
fi


# 下载 task_before.sh
dl_task_before_shell() {
    if [ ! -a "$task_before_shell_path" ]; then
        touch $task_before_shell_path
    fi
    curl -s --connect-timeout 3 https://raw.githubusercontent.com/Oreomeow/VIP/main/Scripts/sh/Helpcode2.8/task_before.sh > $task_before_shell_path
    cp $task_before_shell_path $dir_config/task_before.sh
    # 判断是否下载成功
    task_before_size=$(ls -l $task_before_shell_path | awk '{print $5}')
    if (( $(echo "${task_before_size} < 100" | bc -l) )); then
        echo "task_before.sh 下载失败"
        exit 0
    fi
}
if [ "${Rbefore}" = 'y' -o "${all}" = 1 ]; then
    dl_task_before_shell
else
    echo "已为您跳过替换 task_before.sh"
fi


# 添加定时任务 ql bot
add_ql_bot() {
    if [ "$(grep -c "ql\ bot" /ql/config/crontab.list)" != 0 ]; then
        echo "您的任务列表中已存在 task:ql bot"
    else
        echo "开始添加 task:ql bot"
        # 获取token
        token=$(cat /ql/config/auth.json | jq --raw-output .token)
        curl -s -H 'Accept: application/json' -H "Authorization: Bearer $token" -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept-Language: zh-CN,zh;q=0.9' --data-binary '{"name":"拉取机器人","command":"ql bot","schedule":"13 14 * * *"}' --compressed 'http://127.0.0.1:5700/api/crons?t=1626247933219'
    fi
}
# 运行一次并简单设置 bot.json
set_bot_json() {
    ql bot
    echo -e "------ 机器累了，休息 10s ------"
    sleep 10
    echo -e "\"//user_id\": \"↓↓↓  你的USERID，去除双引号  ↓↓↓\",\n\"user_id\": 123456789,\n\"//bot_token\": \"↓↓↓  你的机器人TOKEN  ↓↓↓\",\n\"bot_token\": \"123456789:ABCDEFGSHSFDASDFAD\",\n\"//api_id\": \"↓↓↓  https://my.telegram.org 在该网站申请到的id  ↓↓↓\",\n\"api_id\": \"456423156\",\n\"//api_hash\": \"↓↓↓  https://my.telegram.org 在该网站申请到的hash  ↓↓↓\",\n\"api_hash\": \"ASDFAWEFADSFAWEFDSFASFD\","
    echo -e "----- 以上为示例，以下为你的配置(不要引号) -----"
    read -p "\"user_id\": " user_id
    read -p "\"bot_token\": " bot_token
    read -p "\"api_id\": " api_id
    read -p "\"api_hash\": " api_hash
    sed -i "s/123456789,/${user_id},/" $bot_json
    sed -ri "s/123456789\:ABCDEFGSHSFDASDFAD/${bot_token}/" $bot_json
    sed -i "s/456423156/${api_id}/" $bot_json
    sed -i "s/ASDFAWEFADSFAWEFDSFASFD/${api_hash}/" $bot_json
}
# 再运行一次 ql bot
run_ql_bot() {
    ql bot
    echo -e "------ 机器累了，休息 10s ------"
    sleep 10
}
if [ "${all}" = 1 ]; then
    add_ql_bot && set_bot_json && run_ql_bot
else
    case ${bot} in
        0)  echo "已为您跳过 bot 操作"
        ;;
        1)  add_ql_bot
        ;;
        2)  add_ql_bot && set_bot_json && run_ql_bot
    esac    
fi


# 添加定时任务 自动更新模板
add_curl_sample() {
    if [ "$(grep -c "config.sample.sh" /ql/config/crontab.list)" != 0 ]; then
        echo "您的任务列表中已存在 task:自动更新模板"
    else
        echo "开始添加 task:curl config.sample.sh"
        # 获取token
        token=$(cat /ql/config/auth.json | jq --raw-output .token)
        curl -s -H 'Accept: application/json' -H "Authorization: Bearer $token" -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept-Language: zh-CN,zh;q=0.9' --data-binary '{"name":"自动更新模板","command":"curl -L https://git.io/config.sh -o /ql/sample/config.sample.sh && cp -rf /ql/sample/config.sample.sh /ql/config","schedule":"45 6,18 * * *"}' --compressed 'http://127.0.0.1:5700/api/crons?t=1627380635389'
    fi
}
run_curl_sample() {
    curl -sL https://git.io/config.sh -o /ql/sample/config.sample.sh && cp -rf /ql/sample/config.sample.sh /ql/config
}
if [ "${all}" = 1 ]; then
    add_curl_sample && run_curl_sample
else
    case ${sample} in
        0)  echo "已为您跳过自动更新模板"
        ;;
        1)  add_curl_sample
        ;;
        2)  add_curl_sample && run_curl_sample
    esac    
fi


# 提示配置结束
echo -e "\n配置到此结束，您是否成功了呢？"
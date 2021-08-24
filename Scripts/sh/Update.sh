#!/usr/bin/env bash

<<'COMMENT'
cron: 32 6,18 * * *
new Env('自用更新');
COMMENT

file_db=/ql/db/env.db
dir_config=/ql/config
dir_scripts=/ql/scripts
dir_raw=/ql/raw
config_raw_path=$dir_raw/config.sh
config_config_path=$dir_config/config.sh
extra_raw_path=$dir_raw/extra.sh
extra_config_path=$dir_config/extra.sh
code_raw_path=$dir_raw/code.sh
code_config_path=$dir_config/code.sh
task_before_raw_path=$dir_raw/task_before.sh
task_before_config_path=$dir_config/task_before.sh

GithubProxyUrl=""
TG_BOT_TOKEN=""
TG_USER_ID=""
openCardBean="10"

CollectedRepo="4"
OtherRepo=""
Ninja="down"

HelpType="HelpType=\"0\""
BreakHelpType="BreakHelpType=\"1\""
BreakHelpNum="BreakHelpNum=\"31-1000\""


update_config() {
    curl -sL https://git.io/config.sh > $config_raw_path
    mv -b $config_raw_path $dir_config
    sed -ri "s/GithubProxyUrl=\"https\:\/\/ghproxy.com\/\"/GithubProxyUrl=\"${GithubProxyUrl}\"/g" $config_config_path
    sed -i "s/TG_BOT_TOKEN=\"\"/TG_BOT_TOKEN=\"${TG_BOT_TOKEN}\"/g" $config_config_path
    sed -i "s/TG_USER_ID=\"\"/TG_USER_ID=\"${TG_USER_ID}\"/g" $config_config_path
    sed -i "s/openCardBean=\"30\"/openCardBean=\"${openCardBean}\"/g" $config_config_path
}

update_extra() {
    curl -sL https://git.io/extra.sh > $extra_raw_path
    mv -b $extra_raw_path $dir_config
    sed -i "s/CollectedRepo=(4)/CollectedRepo=(${CollectedRepo})/g" $extra_config_path
    sed -i "s/OtherRepo=()/OtherRepo=(${OtherRepo})/g" $extra_config_path
    sed -i "s/Ninja=\"up\"/Ninja=\"${Ninja}\"/" $extra_config_path
}

update_code() {
    curl -sL https://git.io/code.sh > $code_raw_path
    mv -b $code_raw_path $dir_config
    sed -i "s/repo=\$repo4/repo=\$repo${repoNum}/g" $code_config_path
    sed -i "/^HelpType=/c${HelpType}" $code_config_path
    sed -i "/^BreakHelpType=/c${BreakHelpType}" $code_config_path
    sed -i "/^BreakHelpNum=/c${BreakHelpNum}" $code_config_path
}

update_task_before() {
    curl -sL https://git.io/task_before.sh > $task_before_raw_path
    mv -b $task_before_raw_path $dir_config
}

random_cookie() {
    c=1000000
    for r in {1..3}; do
        p=`expr $c - $r`
        sed -ri "s/\"position\"\:${p}/regular${r}/" $file_db
    done
    for line in {1..100}; do
        sed -ri "${line}s/(\"position\"\:)[^,]*/\"position\"\:${RANDOM}/" $file_db
    done
    for r in {1..3}; do
        p=`expr $c - $r`
        sed -ri "s/regular${r}/\"position\"\:${p}/" $file_db
    done
    ql check
}

update_ninja() {
    cp -rf /ql/config/sendNotify.js /ql/scripts/sendNotify.js
    cp -rf /ql/config/sendNotify.js /ql/ninja/backend/sendNotify.js
    wget -q https://raw.githubusercontent.com/Oreomeow/VIP/main/Scripts/html/index.html -O /ql/config/index.html
    cp -rf /ql/config/index.html /ql/ninja/backend/static/index.html
    cd /ql/ninja/backend && pm2 start
}


update_config
update_extra
update_code
# update_task_before
update_ninja

if [ $(date "+%H") -eq 18 ]; then
    random_cookie
fi

case $@ in
    ck)
      random_cookie
      ;;
esac
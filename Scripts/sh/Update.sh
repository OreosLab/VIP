#!/usr/bin/env bash
# shellcheck disable=SC2034,2154,2188

<<'COMMENT'
cron: 32 6,18 * * *
new Env('自用更新');
COMMENT

## 导入通用变量与函数
dir_shell=/ql/shell
. $dir_shell/share.sh

file_db_env=/ql/db/env.db
file_raw_config=$dir_raw/config.sh
file_config_config=$dir_config/config.sh
file_raw_extra=$dir_raw/extra.sh
file_config_extra=$dir_config/extra.sh
file_raw_code=$dir_raw/code.sh
file_config_code=$dir_config/code.sh
file_raw_task_before=$dir_raw/task_before.sh
file_config_task_before=$dir_config/task_before.sh
file_config_notify_js=$dir_config/sendNotify.js

GithubProxyUrl=''
TG_BOT_TOKEN=''
TG_USER_ID=''
TG_PROXY_HOST=''
TG_PROXY_PORT=''
openCardBean=''
Recombin_CK_Mode=''
Recombin_CK_ARG1=''
Recombin_CK_ARG2=''
Remove_Void_CK=''
js_deps_replace_envs='js_deps_replace_envs="jdCookie|ql|JD_DailyBonus&sendNotify@JDHelloWorld_jd_scripts|ccwav_QLScript2"'

CollectedRepo=''
OtherRepo=''
RawScript=''
Ninja='down'

repoNum=''
HelpType='HelpType=""'
BreakHelpType='BreakHelpType="1"'
BreakHelpNum='BreakHelpNum="31-1000"'
FixDependType='FixDependType=""'
package_name='package_name="@types/node axios canvas crypto-js date-fns dotenv download form-data fs global-agent got jieba js-base64 jsdom json5 md5 png-js prettytable qrcode-terminal requests require tough-cookie tslib ts-md5 tunnel typescript ws"'
front_num='front_num="1"'

update_config() {
    curl -sL https://raw.githubusercontent.com/Oreomeow/VIP/main/Scripts/sh/Helpcode2.8/config_sample.sh >"$file_raw_config"
    mv -b "$file_raw_config" "$dir_config"
    sed -ri "s/GithubProxyUrl=\"https\:\/\/ghproxy.com\/\"/GithubProxyUrl=\"${GithubProxyUrl}\"/" "$file_config_config"
    sed -i "s/TG_BOT_TOKEN=\"\"/TG_BOT_TOKEN=\"${TG_BOT_TOKEN}\"/" "$file_config_config"
    sed -i "s/TG_USER_ID=\"\"/TG_USER_ID=\"${TG_USER_ID}\"/" "$file_config_config"
    sed -i "s/TG_PROXY_HOST=\"\"/TG_PROXY_HOST=\"${TG_PROXY_HOST}\"/" "$file_config_config"
    sed -i "s/TG_PROXY_PORT=\"\"/TG_PROXY_PORT=\"${TG_PROXY_PORT}\"/" "$file_config_config"
    sed -i "s/openCardBean=\"30\"/openCardBean=\"${openCardBean}\"/" "$file_config_config"
    sed -i "s/Recombin_CK_Mode=\"\"/Recombin_CK_Mode=\"${Recombin_CK_Mode}\"/" "$file_config_config"
    sed -i "s/Recombin_CK_ARG1=\"\"/Recombin_CK_ARG1=\"${Recombin_CK_ARG1}\"/" "$file_config_config"
    sed -i "s/Recombin_CK_ARG2=\"\"/Recombin_CK_ARG2=\"${Recombin_CK_ARG2}\"/" "$file_config_config"
    sed -i "s/Remove_Void_CK=\"\"/Remove_Void_CK=\"${Remove_Void_CK}\"/" "$file_config_config"
    sed -i "/^js_deps_replace_envs=/c${js_deps_replace_envs}" "$file_config_config"
}

update_extra() {
    curl -sL https://raw.githubusercontent.com/Oreomeow/VIP/main/Tasks/qlrepo/extra.sh >"$file_raw_extra"
    mv -b "$file_raw_extra" "$dir_config"
    sed -i "s/CollectedRepo=()/CollectedRepo=(${CollectedRepo})/" "$file_config_extra"
    sed -i "s/OtherRepo=()/OtherRepo=(${OtherRepo})/" "$file_config_extra"
    sed -i "s/RawScript=()/RawScript=(${RawScript})/" "$file_config_extra"
    sed -i "s/Ninja=\"on\"/Ninja=\"${Ninja}\"/" "$file_config_extra"
    echo 'bash /ql/config/Update.sh' >>"$file_config_extra"
}

update_code() {
    curl -sL https://raw.githubusercontent.com/Oreomeow/VIP/main/Scripts/sh/Helpcode2.8/code.sh >"$file_raw_code"
    mv -b "$file_raw_code" "$dir_config"
    sed -i "s/repo=\$repo4/repo=\$repo${repoNum}/" "$file_config_code"
    sed -i "/^HelpType=/c${HelpType}" "$file_config_code"
    sed -i "/^BreakHelpType=/c${BreakHelpType}" "$file_config_code"
    sed -i "/^BreakHelpNum=/c${BreakHelpNum}" "$file_config_code"
    sed -i "/^package_name=/c${package_name}" "$file_config_code"
    sed -i "/^FixDependType=/c${FixDependType}" "$file_config_code"
    sed -i "/^front_num=/c${front_num}" "$file_config_code"
}

update_task_before() {
    curl -sL https://raw.githubusercontent.com/Oreomeow/VIP/main/Scripts/sh/Helpcode2.8/task_before.sh >"$file_raw_task_before"
    mv -b "$file_raw_task_before" "$dir_config"
    sed -i "s/jd_moneyTree_heip/jd_moneyTree*/" "$file_config_task_before"
}

update_ninja() {
    cd /ql && pm2 delete ninja && rm -rf /ql/ninja
    git clone -b master https://github.com/China-Uncle/Waikiki_ninja ninja
    cd /ql/ninja/backend || exit
    pnpm install
    cp -rf /ql/config/.env .env
    pm2 start
    cp -rf /ql/config/sendNotify.js /ql/ninja/backend/sendNotify.js
}

update_config
update_extra
update_code
update_task_before
# update_ninja

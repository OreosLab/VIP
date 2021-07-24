#!/usr/bin/env bash

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
defaultNum=4
repoNum=4


curl -sL https://git.io/config.sh > $config_raw_path
mv -b $config_raw_path $dir_config

curl -sL https://git.io/extra.sh > $extra_raw_path
mv -b $extra_raw_path $dir_config
sed -i "s/\$default4/\$default${defaultNum}/g" $extra_config_path

curl -sL https://git.io/code.sh > $code_raw_path
mv -b $code_raw_path $dir_config
sed -i "s/\$repo4/\$repo${repoNum}/g" $code_config_path
sed -i '/## 填 2 使用“随机顺序互助模板”，本套脚本内账号间随机顺序助力，每次生成的顺序都不一致。/{:a;n;s/1/0/g;/## 定义指定活动采用指定的互助模板。/!ba}' $code_config_path
sed -i '/## 不按示例填写可能引发报错。/{:a;n;s/0/1/g;/## 屏蔽模式/!ba}' $code_config_path
sed -i 's/BreakHelpNum=\"4 9-14 15~18 19_21\"  ## 屏蔽账号序号或序号区间/BreakHelpNum=\"11-47\"  ## 屏蔽账号序号或序号区间/g" $code_config_path

curl -sL https://git.io/task_before.sh > $task_before_raw_path
# mv -b $task_before_raw_path $dir_config

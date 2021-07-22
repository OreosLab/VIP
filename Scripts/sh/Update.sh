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
sed -i "s/\$repo4/\$repoNum${repoNum}/g" $code_config_path

curl -sL https://git.io/task_before.sh > $task_before_raw_path
# mv -b $task_before_raw_path $dir_config

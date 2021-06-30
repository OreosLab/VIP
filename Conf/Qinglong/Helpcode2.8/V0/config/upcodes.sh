#!/usr/bin/env bash

## 导入通用变量与函数
dir_shell=/ql/shell
. $dir_shell/share.sh

#读取最新日志
code_log_newest=`ls -at $dir_code/*  | head -n 1`
source $code_log_newest

#更新配置文件中互助码的函数。其中 {1..43..1} 表示“从 1 读取到 43” 
update_codes(){
local envs=$(eval echo "\$JD_COOKIE")
local array=($(echo $envs | sed 's/&/ /g'))
local user_sum=${#array[*]}
for ((i=1; i<=$user_sum; i++)); do
   new_code=`cat $code_log_newest | grep "^My$1$i=" | sed "s/.*'\(.*\)'.*/\1/"`
   old_code=`cat $file_task_before | grep "^My$1$i=" | sed "s/.*'\(.*\)'.*/\1/"`
   if [ -z "$(grep "^My$1$i" $file_task_before)" ]; then
      sed -i "/^My$1$[$i-1]='.*'/ s/$/\nMy$1$i=\'\'/" $file_task_before
   fi
   if [[ -n "$new_code" ]] && [[ "$new_code" != "undefined" ]]; then
      if [ "$new_code" != "$old_code" ]; then
         sed -i "s/^My$1$i='$old_code'$/My$1$i='$new_code'/" $file_task_before
      fi
   fi
done
}

update_help(){
local envs=$(eval echo "\$JD_COOKIE")
local array=($(echo $envs | sed 's/&/ /g'))
local user_sum=${#array[*]}
for ((i=1; i<=$user_sum; i++)); do
   new_help=`cat $code_log_newest | grep "^ForOther$1$i=" | sed 's/.*"\(.*\)".*/\1/'`
   old_help=`cat $file_task_before | grep "^ForOther$1$i=" | sed 's/.*"\(.*\)".*/\1/'`
   if [ -z "$(grep "^ForOther$1$i" $file_task_before)" ]; then
      sed -i "/^ForOther$1$[$i-1]=".*"/ s/$/\nForOther$1$i=\"\"/" $file_task_before
   fi
   if [ -n "$new_help" ]; then
      if [ "$new_help" != "$old_help" ]; then
         sed -i "s/^ForOther$1$i=\"$old_help\"$/ForOther$1$i=\"$new_help\"/" $file_task_before
      fi
   fi
done
}

if [ -f $code_log_newest ] && [ -f $file_task_before ]; then
   update_codes Fruit
   update_codes Pet
   update_codes Bean
   update_codes JdFactory
   update_codes DreamFactory
   update_codes Jdzz
   update_codes Joy
   update_codes BookShop
   update_codes Cash
   update_codes Jxnc
   update_codes Sgmh
   update_codes Cfd
   update_codes Health
   update_codes Carni
   update_codes City

   update_help Fruit
   update_help Pet
   update_help Bean
   update_help JdFactory
   update_help DreamFactory
   update_help Jdzz
   update_help Joy
   update_help BookShop
   update_help Cash
   update_help Jxnc
   update_help Sgmh
   update_help Cfd
   update_help Health
   update_help Carni
   update_help City
elif [ ! -f $code_log_newest ]; then
   echo 日志文件不存在，请检查设置后重试！
elif [ ! -f $file_task_before ]; then
   echo 配置文件不存在，请检查设置后重试！
fi


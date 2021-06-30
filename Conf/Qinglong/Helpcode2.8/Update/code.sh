#!/usr/bin/env bash

#Build 20210630-001

## 导入通用变量与函数
dir_shell=/ql/shell
. $dir_shell/share.sh

## 判断仓库类别及日志存在与否
repo1='panghu999'
repo2='JDHelloWorld'
repo3='chinnkarahoi'
if [ "$(ls $dir_log |grep panghu999_jd_scripts | wc -l)" -gt 0 ]; then
    repo=$repo1
elif [ "$(ls $dir_log |grep JDHelloWorld | wc -l)" -gt 0 ]; then
    repo=$repo2
elif [ "$(ls $dir_log |grep chinnkarahoi | wc -l)" -gt 0 ]; then
    repo=$repo3
else
    repo=''
fi

## 调试模式开关，默认是0，表示关闭；设置为1，表示开启
DEBUG="1"

## 备份配置文件开关，默认是1，表示开启；设置为0，表示关闭。备份路径 /ql/config/bak/
BAKUP="1"

## 自定义屏蔽账号被助力，不影响被屏蔽的账号助力别的账号。BreakHelpType="1"或BreakHelpType="2"表示指定模式。不填或其他值表示不开启
## 设定值为 1 或 2。不填或其他值表示不开启
BreakHelpType=""

## 自定义屏蔽被助力的账号起始序号。当 BreakType="1"时生效。
## 设定值为正整数，不大于账号总数。如 6 表示从第 6 个账号到最后一个账号均不被助力
BreakHelpStartNum="6"

## 自定义屏蔽被助力的账号序号。当 BreakHelp="2"时生效。
## 设定值为正整数，不大于账号总数。如 5 7 8 10 表示第 5 7 8 10 个账号均不被助力
BreakHelpNum="5 7 8 10"

## 定义 jcode 脚本导出的互助码模板样式（选填）
## 不填 使用“按编号顺序助力模板”，Cookie编号在前的优先助力
## 填 0 使用“全部一致助力模板”，所有账户要助力的码全部一致
## 填 1 使用“均等机会助力模板”，所有账户获得助力次数一致
## 填 2 使用“随机顺序助力模板”，本套脚本内账号间随机顺序助力，每次生成的顺序都不一致。
HelpType="1"

## 定义是否自动更新配置文件中的互助码和互助规则，默认为1，表示更新；留空或其他数值表示不更新。
UpdateType="1"

## 需组合的环境变量列表，env_name需要和var_name一一对应，如何有新活动按照格式添加(不懂勿动)
env_name=(
  FRUITSHARECODES
  PETSHARECODES
  PLANT_BEAN_SHARECODES
  DREAM_FACTORY_SHARE_CODES
  DDFACTORY_SHARECODES
  JDJOY_SHARECODES
  JDZZ_SHARECODES
  JXNC_SHARECODES
  BOOKSHOP_SHARECODES
  JD_CASH_SHARECODES
  JDSGMH_SHARECODES
  JDCFD_SHARECODES
  JDHEALTH_SHARECODES
  JD818_SHARECODES
  CITY_SHARECODES
)
var_name=(
  ForOtherFruit
  ForOtherPet
  ForOtherBean
  ForOtherDreamFactory
  ForOtherJdFactory
  ForOtherJoy
  ForOtherJdzz
  ForOtherJxnc
  ForOtherBookShop
  ForOtherCash
  ForOtherSgmh
  ForOtherCfd
  ForOtherHealth
  ForOtherCarni
  ForOtherCity
)

## name_js为脚本文件名，如果使用ql repo命令拉取，文件名含有作者名
## 所有有互助码的活动，把脚本名称列在 name_js 中，对应 config.sh 中互助码后缀列在 name_config 中，中文名称列在 name_chinese 中。
## name_js、name_config 和 name_chinese 中的三个名称必须一一对应。
name_js=(
  "$repo"_jd_scripts_jd_fruit
  "$repo"_jd_scripts_jd_pet
  "$repo"_jd_scripts_jd_plantBean
  "$repo"_jd_scripts_jd_dreamFactory
  "$repo"_jd_scripts_jd_jdfactory
  "$repo"_jd_scripts_jd_crazy_joy
  "$repo"_jd_scripts_jd_jdzz
  "$repo"_jd_scripts_jd_jxnc
  "$repo"_jd_scripts_jd_bookshop
  "$repo"_jd_scripts_jd_cash
  "$repo"_jd_scripts_jd_sgmh
  "$repo"_jd_scripts_jd_cfd
  "$repo"_jd_scripts_jd_health
  "$repo"_jd_scripts_jd_carnivalcity
  "$repo"_jd_scripts_jd_city
)

name_config=(
  Fruit
  Pet
  Bean
  DreamFactory
  JdFactory
  Joy
  Jdzz
  Jxnc
  BookShop
  Cash
  Sgmh
  Cfd
  Health
  Carni
  City
)

name_chinese=(
  东东农场
  东东萌宠
  京东种豆得豆
  京喜工厂
  东东工厂
  crazyJoy任务
  京东赚赚
  京喜农场
  口袋书店
  签到领现金
  闪购盲盒
  京喜财富岛
  东东健康社区
  京东手机狂欢城
  城城领现金
)

## 生成pt_pin清单
gen_pt_pin_array() {
  local envs=$(eval echo "\$JD_COOKIE")
  local array=($(echo $envs | sed 's/&/ /g'))
  local tmp1 tmp2 i pt_pin_temp
  for i in "${!array[@]}"; do
    pt_pin_temp=$(echo ${array[i]} | perl -pe "{s|.*pt_pin=([^; ]+)(?=;?).*|\1|; s|%|\\\x|g}")
    [[ $pt_pin_temp == *\\x* ]] && pt_pin[i]=$(printf $pt_pin_temp) || pt_pin[i]=$pt_pin_temp
  done
}

## 导出互助码的通用程序，$1：去掉后缀的脚本名称，$2：config.sh中的后缀，$3：活动中文名称
export_codes_sub() {
    local task_name=$1
    local config_name=$2
    local chinese_name=$3
    local config_name_my=My$config_name
    local config_name_for_other=ForOther$config_name
    local i j k m n pt_pin_in_log code tmp_grep tmp_my_code tmp_for_other user_num random_num_list
    local envs=$(eval echo "\$JD_COOKIE")
    local array=($(echo $envs | sed 's/&/ /g'))
    local user_sum=${#array[*]}
    if cd $dir_log/$task_name &>/dev/null && [[ $(ls) ]]; then
        ## 寻找所有互助码以及对应的pt_pin
        i=0
        pt_pin_in_log=()
        code=()
        pt_pin_and_code=$(ls -r *.log | xargs awk -v var="的$chinese_name好友互助码" 'BEGIN{FS="[（ ）】]+"; OFS="&"} $3~var {print $2,$4}')
        for line in $pt_pin_and_code; do
            pt_pin_in_log[i]=$(echo $line | awk -F "&" '{print $1}')
            code[i]=$(echo $line | awk -F "&" '{print $2}')
            let i++
        done

        ## 输出My系列变量
        if [[ ${#code[*]} -gt 0 ]]; then
            for ((m = 0; m < ${#pt_pin[*]}; m++)); do
                tmp_my_code=""
                j=$((m + 1))
                for ((n = 0; n < ${#code[*]}; n++)); do
                    if [[ ${pt_pin[m]} == ${pt_pin_in_log[n]} ]]; then
                        tmp_my_code=${code[n]}
                        break
                    fi
                done
                echo "$config_name_my$j='$tmp_my_code'"
            done
        else
            echo "## 从日志中未找到任何互助码"
        fi

        ## 输出ForOther系列变量
        if [[ ${#code[*]} -gt 0 ]]; then
            echo
            case $HelpType in
            0) ## 全部一致
                tmp_for_other=""
                for ((m = 0; m < ${#pt_pin[*]}; m++)); do
                    j=$((m + 1))
                    tmp_for_other="$tmp_for_other@\${$config_name_my$j}"
                done
                echo "${config_name_for_other}1=\"$tmp_for_other\"" | perl -pe "s|($config_name_for_other\d+=\")@|\1|"
                for ((m = 1; m < ${#pt_pin[*]}; m++)); do
                    j=$((m + 1))
                    echo "$config_name_for_other$j=\"\${${config_name_for_other}1}\""
                done
                ;;

            1) ## 均等助力
                for ((m = 0; m < ${#pt_pin[*]}; m++)); do
                    tmp_for_other=""
                    j=$((m + 1))
                    for ((n = $m; n < $(($user_sum + $m)); n++)); do
                        [[ $m -eq $n ]] && continue
                        if [[ $((n + 1)) -le $user_sum ]]; then
                            k=$((n + 1))
                        else
                            k=$((n + 1 - $user_sum))
                        fi
                        tmp_for_other="$tmp_for_other@\${$config_name_my$k}"
                    done
                    echo "$config_name_for_other$j=\"$tmp_for_other\"" | perl -pe "s|($config_name_for_other\d+=\")@|\1|"
                done
                ;;

            2) ## 本套脚本内账号间随机顺序助力
                for ((m = 0; m < ${#pt_pin[*]}; m++)); do
                    tmp_for_other=""
                    random_num_list=$(seq $user_sum | sort -R)
                    j=$((m + 1))
                    for n in $random_num_list; do
                        [[ $j -eq $n ]] && continue
                        tmp_for_other="$tmp_for_other@\${$config_name_my$n}"
                    done
                    echo "$config_name_for_other$j=\"$tmp_for_other\"" | perl -pe "s|($config_name_for_other\d+=\")@|\1|"
                done
                ;;

            *) ## 按编号优先
                for ((m = 0; m < ${#pt_pin[*]}; m++)); do
                    tmp_for_other=""
                    j=$((m + 1))
                    for ((n = 0; n < ${#pt_pin[*]}; n++)); do
                        [[ $m -eq $n ]] && continue
                        k=$((n + 1))
                        tmp_for_other="$tmp_for_other@\${$config_name_my$k}"
                    done
                    echo "$config_name_for_other$j=\"$tmp_for_other\"" | perl -pe "s|($config_name_for_other\d+=\")@|\1|"
                done
                ;;
            esac
        fi
    else
        echo "## 未运行过 $task_name.js 脚本，未产生日志"
    fi
}

## 汇总输出
export_all_codes() {
    gen_pt_pin_array
    [[ $DEBUG = "1" ]] && echo "# 当前 code.sh 的线程数量：$(ps | grep code.sh | grep -v grep | wc -l)"
	[[ $DEBUG = "1" ]] && echo -e "\n# 预设的 COOKIES 数量：`echo $JD_COOKIE | grep -o 'pt_key' | wc -l`"
	[[ $DEBUG = "1" ]] && echo -e "\n# 预设的 COOKIES 环境变量数量：`echo $JD_COOKIE | sed 's/&/\n/g' | wc -l`"
	[[ $DEBUG = "1" && "$(echo $JD_COOKIE | sed 's/&/\n/g' | wc -l)" = "1" && "$(echo $JD_COOKIE | grep -o 'pt_key' | wc -l)" -gt 1 ]] && echo -e "\n# 检测到您将多个 COOKIES 填写到单个环境变量值，请注意将各 COOKIES 采用 & 分隔，否则将无法完整输出互助码及互助规则！"
    echo -e "\n# 从日志提取互助码，编号和配置文件中Cookie编号完全对应，如果为空就是所有日志中都没有。\n\n# 即使某个MyXxx变量未赋值，也可以将其变量名填在ForOtherXxx中，jtask脚本会自动过滤空值。\n"
    echo -n "# 你选择的互助码模板为："
    case $HelpType in
    0)
        echo "所有账号助力码全部一致。"
        ;;
    1)
        echo "所有账号机会均等助力。"
        ;;
    2)
        echo "本套脚本内账号间随机顺序助力。"
        ;;
    *)
        echo "按账号编号优先。"
        ;;
    esac
    if [ "$(ps | grep code.sh | grep -v grep | wc -l)" -gt 8 ]; then
        echo -e "\n# 检测到 code.sh 的线程过多 ，请稍后再试！"
		exit
    elif [ -z $repo ]; then
        echo -e "\n# 未检测到兼容的活动脚本日志，无法读取互助码，退出！"
		exit
    else
        echo -e "\n# 优先读取 $repo 的脚本日志，格式化导出互助码，生成互助规则！"
        for ((i = 0; i < ${#name_js[*]}; i++)); do
            echo -e "\n## ${name_chinese[i]}："
            export_codes_sub "${name_js[i]}" "${name_config[i]}" "${name_chinese[i]}"
        done
    fi
}

#更新配置文件中互助码的函数
help_codes(){
if [ -z "$(cat $file_task_before | grep "^My$1\d")" ]; then
   echo "" >> $file_task_before
   echo "My"$1"1=''" >> $file_task_before
   echo "" >> $file_task_before
fi
local envs=$(eval echo "\$JD_COOKIE")
local array=($(echo $envs | sed 's/&/ /g'))
local user_sum=${#array[*]}
for ((i=1; i<=$user_sum; i++)); do
   new_code=`cat $code_log_newest | grep "^My$1$i=.*'$" | sed "s/.*'\(.*\)'.*/\1/"`
   old_code=`cat $file_task_before | grep "^My$1$i=.*'$" | sed "s/.*'\(.*\)'.*/\1/"`
   if [ -z "$(grep "^My$1$i" $file_task_before)" ]; then
      sed -i "/^My$1$[$i-1]='.*'/ s/$/\nMy$1$i=\'\'/" $file_task_before
   fi
   if [[ "$new_code" != "" ]] && [[ "$new_code" != "undefined" ]] && [[ "$new_code" != "{}" ]]; then
      if [ "$new_code" != "$old_code" ]; then
         sed -i "s/^My$1$i='$old_code'$/My$1$i='$new_code'/" $file_task_before
      fi
   fi
done
}

#更新配置文件中互助规则的函数
help_rules(){
if [ -z "$(cat $file_task_before | grep "^ForOther$1\d")" ]; then
   echo "ForOther"$1"1=\"\"" >> $file_task_before
   echo "" >> $file_task_before
fi
local envs=$(eval echo "\$JD_COOKIE")
local array=($(echo $envs | sed 's/&/ /g'))
local user_sum=${#array[*]}
for ((i=1; i<=$user_sum; i++)); do
   new_rule=`cat $code_log_newest | grep "^ForOther$1$i=.*\"$" | sed "s/.*\"\(.*\)\".*/\1/"`
   old_rule=`cat $file_task_before | grep "^ForOther$1$i=.*\"$" | sed "s/.*\"\(.*\)\".*/\1/"`
   if [ -z "$(grep "^ForOther$1$i" $file_task_before)" ]; then
      sed -i "/^ForOther$1$[$i-1]=".*"/ s/$/\nForOther$1$i=\"\"/" $file_task_before
   fi
   if [ "$new_rule" != "" ]; then
      if [ "$new_rule" != "$old_rule" ]; then
         sed -i "s/^ForOther$1$i=\"$old_rule\"$/ForOther$1$i=\"$new_rule\"/" $file_task_before
      fi
   fi
done
}

break_help(){
local envs=$(eval echo "\$JD_COOKIE")
local array=($(echo $envs | sed 's/&/ /g'))
local user_sum=${#array[*]}
case $BreakHelpType in
    1)
        for ((i = $BreakHelpStartNum; i <= $user_sum; i++)); do
            sed -i "s/@\?\${My[A-Za-z]\+$i}@\?//g" $file_task_before
        done
        ;;
    2)
        for i in $BreakHelpNum; do
            sed -i "s/@\?\${My[A-Za-z]\+$i}@\?//g" $file_task_before
        done
        ;;
esac
}

#更新互助码和互助规则
update_help(){
code_log_newest=`ls -at $dir_code/*  | head -n 1`
source $code_log_newest
case $UpdateType in
    1) 
        if [ -f $code_log_newest ] && [ -f $file_task_before ]; then
            mkdir -p $dir_config/bak
            [[ $BAKUP = "1" ]] && cp $file_task_before $dir_config/bak/task_before_$log_time.sh
            echo -e "\n# 开始更新配置文件的互助码和互助规则"
            help_codes Fruit
            help_rules Fruit
            help_codes Pet
            help_rules Pet
            help_codes Bean
            help_rules Bean
            help_codes JdFactory
            help_rules JdFactory
            help_codes DreamFactory
            help_rules DreamFactory
            help_codes Jdzz
            help_rules Jdzz
            help_codes Joy
            help_rules Joy
            help_codes BookShop
            help_rules BookShop
            help_codes Cash
            help_rules Cash
            help_codes Jxnc
            help_rules Jxnc
            help_codes Sgmh
            help_rules Sgmh
            help_codes Cfd
            help_rules Cfd
            help_codes Health
            help_rules Health
            help_codes Carni
            help_rules Carni
            help_codes City
            help_rules City
			break_help
            echo -e "\n# 配置文件的互助码和互助规则已完成更新"
        elif [ ! -f $code_log_newest ]; then
            echo -e "\n# 日志文件不存在，请检查后重试！"
        elif [ ! -f $file_task_before ]; then
            echo -e "\n# 配置文件不存在，请检查后重试！"
        fi
        ;;
    *)
        echo -e "\n# 您已设置不更新配置文件的互助码和互助规则"
        ;;
esac
}

## 执行并写入日志
log_time=$(date "+%Y-%m-%d-%H-%M-%S")
log_path="$dir_code/$log_time.log"
make_dir "$dir_code"
export_all_codes | perl -pe "{s|京东种豆|种豆|; s|crazyJoy任务|疯狂的JOY|}" | tee $log_path
sleep 5
update_help


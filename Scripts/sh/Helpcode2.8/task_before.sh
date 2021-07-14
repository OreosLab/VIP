#!/usr/bin/env bash

# Build 20210714-001

## 东东农场：
MyFruit1=''

ForOtherFruit1=""


## 东东萌宠：
MyPet1=''

ForOtherPet1=""


## 种豆得豆：
MyBean1=''

ForOtherBean1=""


## 京喜工厂：
MyDreamFactory1=''

ForOtherDreamFactory1=""


## 东东工厂：
MyJdFactory1=''

ForOtherJdFactory1=""


## 疯狂的JOY：
MyJoy1=''

ForOtherJoy1=""


## 京东赚赚：
MyJdzz1=''

ForOtherJdzz1=""


## 京喜农场：
MyJxnc1=''

ForOtherJxnc1=""


## 口袋书店：
MyBookShop1=''

ForOtherBookShop1=""


## 签到领现金：
MyCash1=''

ForOtherCash1=""


## 闪购盲盒：
MySgmh1=''

ForOtherSgmh1=""


## 京喜财富岛：
MyCfd1=''

ForOtherCfd1=""


## 东东健康社区：
MyHealth1=''

ForOtherHealth1=""


## 京东手机狂欢城：
MyCarni1=''

ForOtherCarni1=""


## 城城领现金：
MyCity1=''

ForOtherCity1=""

## 京喜农场 Token (可用于京喜财富岛提现等)
TokenJxnc1=''

env_name=(
  FRUITSHARECODES   ## 东东农场互助码
  PETSHARECODES   ## 东东萌宠互助码
  PLANT_BEAN_SHARECODES   ## 种豆得豆互助码
  DREAM_FACTORY_SHARE_CODES  ## 京喜工厂互助码
  DDFACTORY_SHARECODES   ## 东东工厂互助码
  JDJOY_SHARECODES   ## 疯狂的JOY互助码
  JDZZ_SHARECODES   ## 京东赚赚互助码
  JXNC_SHARECODES  ## 京喜农场助力码
  BOOKSHOP_SHARECODES   ## 口袋书店互助码
  JD_CASH_SHARECODES   ## 签到领现金互助码
  JDSGMH_SHARECODES   ## 闪购盲盒互助码
  JDCFD_SHARECODES   ## 京喜财富岛互助码
  JDHEALTH_SHARECODES   ## 东东健康社区互助码
  CITY_SHARECODES   ## lxk城城领现金
  JD818_SHARECODES   ## lxk手机狂欢城
  jxcollecturl   ## 执意Ariszy京喜工厂收取电力
  MyZooPk
  MyZoo
  JXNCTOKENS   ## 京喜农场 token(京喜财富岛提现用)
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
  Jxcollecturl
  MyZooPk
  MyZoo
  TokenJxnc
)

combine_sub() {
    local what_combine=$1
    local combined_all=""
    local tmp1 tmp2
    local envs=$(eval echo "\$JD_COOKIE")
    local array=($(echo $envs | sed 's/&/ /g'))
    local user_sum=${#array[*]}
    for ((i = 1; i <= $user_sum; i++)); do
        for num in ${TempBlockCookie}; do
            if [[ $i -eq $num ]]; then
             continue 2
            fi
        done
        local tmp1=$what_combine$i
        local tmp2=${!tmp1}
        combined_all="$combined_all&$tmp2"
    done
    echo $combined_all | perl -pe "{s|^&||; s|^@+||; s|&@|&|g; s|@+&|&|g; s|@+|@|g; s|@+$||}"
}

## 正常依次运行时，组合所有账号的Cookie与互助码
combine_all() {
    for ((i = 0; i < ${#env_name[*]}; i++)); do
        result=$(combine_sub ${var_name[i]})
        if [[ $result ]]; then
            export ${env_name[i]}="$result"
        fi
    done
}

## 临时屏蔽某账号运行活动脚本
TempBlock_JD_COOKIE(){
    . $file_env
    local envs=$(eval echo "\$JD_COOKIE")
    local array=($(echo $envs | sed 's/&/ /g'))
    for i in $TempBlockCookie; do
	    unset array[$(($i-1))]
	done
	jdCookie=$(echo ${array[*]} | sed 's/\ /\&/g')
	[[ ! -z $jdCookie ]] && export JD_COOKIE="$jdCookie"
}

TempBlock_JD_COOKIE

#if [[ $(ls $dir_code) ]]; then
#    latest_log=$(ls -r $dir_code | head -1)
#    . $dir_code/$latest_log
    combine_all
#fi

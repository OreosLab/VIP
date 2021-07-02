#!/usr/bin/env bash

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
## 从日志中未找到任何互助码

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
)

combine_sub() {
    local what_combine=$1
    local combined_all=""
    local tmp1 tmp2
    local envs=$(eval echo "\$JD_COOKIE")
    local array=($(echo $envs | sed 's/&/ /g'))
    local user_sum=${#array[*]}
    for ((i = 1; i <= $user_sum; i++)); do
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

combine_all


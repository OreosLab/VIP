#!/usr/bin/env bash

## 东东农场：
MyFruit1='a1bc1602151a42d68fb8cf0ee93cc43d'

ForOtherFruit1="${MyFruit2}@${MyFruit3}@${MyFruit4}@${MyFruit5}@${MyFruit6}"

## 东东萌宠：
MyPet1='MTAxODc2NTEzNDAwMDAwMDAyNzkyNjM4Mw=='

ForOtherPet1="${MyPet2}@${MyPet3}@${MyPet4}@${MyPet5}@${MyPet6}"

## 种豆得豆：
MyBean1='qu73szyyke7tv4sgpjojpyiq6u'

ForOtherBean1="${MyBean2}@${MyBean3}@${MyBean4}@${MyBean5}@${MyBean6}"

## 京喜工厂：
## 未运行过 chinnkarahoi_jd_scripts_jd_dreamFactory.js 脚本，未产生日志

## 东东工厂：
## 未运行过 chinnkarahoi_jd_scripts_jd_jdfactory.js 脚本，未产生日志

## 京东赚赚：
## 未运行过 chinnkarahoi_jd_scripts_jd_jdzz.js 脚本，未产生日志

## 疯狂的JOY：
MyJoy1='7sHHyK1wYkSrfc3eWGgXhA=='

ForOtherJoy1="${MyJoy2}@${MyJoy3}@${MyJoy4}@${MyJoy5}@${MyJoy6}"

## 京喜农场：
## 未运行过 chinnkarahoi_jd_scripts_jd_jxnc.js 脚本，未产生日志

## 口袋书店：
## 从日志中未找到任何互助码

## 签到领现金：
MyCash1='UGhDLrnjO6E'

ForOtherCash1="${MyCash2}@${MyCash3}@${MyCash4}@${MyCash5}@${MyCash6}"

## 闪购盲盒：
MySgmh1='T011zY4HAktIqAkCjVQmoaT5kRrbA'

ForOtherSgmh1="${MySgmh2}@${MySgmh3}@${MySgmh4}@${MySgmh5}@${MySgmh6}"

## 京喜财富岛：
MyCfd1='A67DCF4DB27DC9D742C45717E86921109FC21B4EB18F625C865785E2C8261FAA'

ForOtherCfd1="${MyCfd2}@${MyCfd3}@${MyCfd4}@${MyCfd5}@${MyCfd6}"

## 东东健康社区：
MyHealth1='T011zY4HAktIqAkCjVfnoaW5kRrbA'

ForOtherHealth1="${MyHealth2}@${MyHealth3}@${MyHealth4}@${MyHealth5}@${MyHealth6}"

env_name=(
  FRUITSHARECODES
  PETSHARECODES
  PLANT_BEAN_SHARECODES
  DREAM_FACTORY_SHARE_CODES
  DDFACTORY_SHARECODES
  JDZZ_SHARECODES
  JDJOY_SHARECODES
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
  ForOtherJdzz
  ForOtherJoy
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
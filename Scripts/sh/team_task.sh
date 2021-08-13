#!/usr/bin/env bash

<<'COMMENT'
Method 1: team_task 11 1 "smiek2221_scripts_gua_xmGame.js"
Cron: 16 * * * *  sh_team_task.sh
COMMENT

## 组队任务
team_task(){
    local p=$1                       ## 组队总账号数
    local q=$2                       ## 每个账号发起组队的最大队伍数量
    local scr=$3                     ## 活动脚本完整文件名
    export jd_zdjr_activityId=$4     ## 活动 activityId；需手动抓包
    export jd_zdjr_activityUrl=$5    ## 活动 activityUrl；需手动抓包
    . /ql/config/env.sh
    local envs=$(eval echo "\$JD_COOKIE")
    local array=($(echo $envs | sed 's/&/ /g'))
    local user_sum=${#array[*]}
    local a b i j t sum
    for ((m = 0; m < $user_sum; m++)); do
        j=$((m + 1))
        x=$((m/q))
        y=$(((p - 1)*m + 1))
        COOKIES_HEAD="${array[x]}"
        COOKIES=""
        if [[ $j -le $q ]]; then
            for ((n = 1; n < $p; n++)); do
                COOKIES="$COOKIES&${array[y]}"
                let y++
            done
        elif [[ $j -eq $((q + 1)) ]]; then
            for ((n = 1; n < $((p-1)); n++)); do
                COOKIES_HEAD="${array[x]}&${array[0]}"
                COOKIES="$COOKIES&${array[y]}"
                let y++
            done
        elif [[ $j -gt $((q + 1)) ]]; then
            [[ $((y+1)) -le $user_sum ]] && y=$(((p - 1)*m)) || break
            for ((n = $m; n < $((m + p -1)); n++)); do
                COOKIES="$COOKIES&${array[y]}"
                let y++
                [[ $y = $x ]] && y=$((y+1))
                [[ $((y+1)) -gt $user_sum ]] && break
            done
        fi
        result=$(echo -e "$COOKIES_HEAD$COOKIES")
        if [[ $result ]]; then
            export JD_COOKIE=$result
            case $scr in
                *.js)
                    node /ql/scripts/$scr
                    ;;
                *.sh)
                    bash /ql/scripts/$scr
                    ;;
            esac
        fi
#        echo $JD_COOKIE
    done
}

gua_xmGame=`find . -type f -name "*gua_xmGame.js"|head -1`
team_task 11 1 "${gua_xmGame}"  ##小米-星空大冒险

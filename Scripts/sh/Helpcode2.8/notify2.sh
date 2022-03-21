#!/usr/bin/env bash

Ver="Build 20220314-001-Alpha"

## 导入通用变量与函数
dir_shell=/ql/shell
. $dir_shell/share.sh
. $dir_shell/api.sh

# 定义 json 数据查询工具
def_envs_tool() {
    for i in $@; do
        . $dir_shell/api.sh
        curl -s --noproxy "*" "http://0.0.0.0:5600/api/envs?searchValue=$i" -H "Authorization: Bearer $token" | jq .data | perl -pe "{s|^\[\|\]$||g; s|\n||g; s|\},$|\}\n|g}"
    done
}

def_envs_match() {
    def_envs_tool $1 | grep "$2" | jq -r .$3 | grep -v "null"
}

def_json_match() {
    if [[ -f $1 ]]; then
        if [[ $3 && $(cat "$1" | grep "$3") ]]; then
            cat "$1" | perl -pe '{s|^\[\|\]$||g; s|\n||g; s|\},$|\}\n|g}' | grep "$2" | jq -r .$3 | grep -v "null"
        else
            cat "$1" | perl -pe '{s|^\[\|\]$||g; s|\n||g; s|\},$|\}\n|g}' | grep "$2" | grep -v "null"
        fi
    fi
}

def_json_value() {
    if [[ -f $1 ]]; then
        if [[ $(cat "$1" | grep "$2") ]]; then
            cat "$1" | perl -pe "{s|^\[\|\]$||g; s|\n||g; s|\},$|\}\n|g}" | grep "$3" | jq -r .$2 | grep -v "null"
        fi
    fi
}

## WxPusher 通知 API
WxPusher_notify_api() {
    local appToken=$1
    local uids=$2
    local title=$3
    local summary=$4
    local content=$5
    local frontcontent=$6
    local summary=$(echo -e "$title\n\n$summary" | perl -pe '{s|(\")|'\\'\\1|g; s|\n|<br>|g}')
    [[ ${#summary} -ge 100 ]] && local summary="${summary:0:90} ……"
    local content=$(echo -e "$title\n\n$content" | perl -pe '{s|(\")|'\\'\\1|g; s|\n|<br>|g}')
    local url="http://wxpusher.zjiecode.com/api/send/message"

    local api=$(
        curl -s --noproxy "*" "$url" \
            -X 'POST' \
            -H "Content-Type: application/json" \
            --data-raw "{\"appToken\":\"${appToken}\",\"content\":\"${content}\",\"summary\":\"${summary}\",\"contentType\":\"2\",\"uids\":[$uids]}"
    )
    code=$(echo $api | jq -r .code)
    msg=$(echo $api | jq -r .msg)
    if [[ $code == 1000 ]]; then
        echo -e "#$frontcontent WxPusher 消息发送成功(${uids})\n"
    else
        [[ ! $msg ]] && msg="访问 API 超时"
        echo -e "#$frontcontent WxPusher 消息发送处理失败(${msg})\n"
    fi
}

## 企业微信应用通知 API
QYWX_notify_api() {
    local corpid="$(echo $1 | awk -F ',' '{print $1}')"
    local corpsecret="$(echo $1 | awk -F ',' '{print $2}')"
    local userId="$(echo $1 | awk -F ',' '{print $3}')"
    local agentid="$(echo $1 | awk -F ',' '{print $4}')"
    local thumb_media_id="$(echo $1 | awk -F ',' '{print $5}')"
    local author=$2
    local title=$3
    local digest=$4
    local content=$5
    local frontcontent=$6
    local ACCESS_TOKEN
    local digest=$(echo -e "$digest" | perl -pe '{s|(\")|'\\'\\1|g}')
    local content=$(echo -e "$content" | perl -pe '{s|(\")|'\\'\\1|g; s|\n|<br>|g}')
    local url="https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=${corpid}&corpsecret=${corpsecret}"

    local api=$(
        curl -s --noproxy "*" "$url"
    )

    local code=$(echo $api | jq -r .errcode)
    local msg=$(echo $api | jq -r .errmsg)
    if [[ $code == 0 ]]; then
        ACCESS_TOKEN=$(echo $api | jq -r .access_token)
        local url="https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=${ACCESS_TOKEN}"

        if [[ $thumb_media_id ]]; then
            local api=$(
                curl -s --noproxy "*" "$url" \
                    -X 'POST' \
                    -H "Content-Type: application/json" \
                    --data-raw "{\"touser\":\"$userId\",\"msgtype\":\"mpnews\",\"agentid\":\"$agentid\",\"mpnews\":{\"articles\":[{\"title\":\"$title\",\"thumb_media_id\":\"$thumb_media_id\",\"author\":\"$author\",\"content\":\"$content\",\"digest\":\"$digest\"}]}}"
            )
        else
            local api=$(
                curl -s --noproxy "*" "$url" \
                    -X 'POST' \
                    -H "Content-Type: application/json" \
                    --data-raw "{\"touser\":\"$userId\",\"msgtype\":\"mpnews\",\"agentid\":\"$agentid\",\"mpnews\":{\"articles\":[{\"title\":\"$title\",\"thumb_media_id\":\"$thumb_media_id\",\"author\":\"$author\",\"content\":\"$content\",\"digest\":\"$digest\"}]}}"
            )
        fi

        code=$(echo $api | jq -r .errcode)
        msg=$(echo $api | jq -r .errmsg)
        if [[ $code == 0 ]]; then
            echo -e "#$frontcontent 企业微信应用消息发送成功\n"
        else
            [[ ! $msg ]] && msg="访问 API 超时"
            echo -e "#$frontcontent 企业微信应用消息发送处理失败(${msg})\n"
        fi
    fi
}

## pushplus 通知 API
pushplus_notify_api() {
    local token=$1
    local topic=$2
    local title=$3
    local content=$4
    local frontcontent=$5
    local content=$(echo -e "$content" | perl -pe '{s|(\")|'\\'\\1|g; s|\n|<br>|g}')
    local url="http://www.pushplus.plus/send"

    local api=$(
        curl -s --noproxy "*" "$url" \
            -X 'POST' \
            -H "Content-Type: application/json" \
            --data-raw "{\"token\":\"$token\",\"title\":\"$title\",\"content\":\"$content\"}"
    )

    code=$(echo $api | jq -r .code)
    msg=$(echo $api | jq -r .msg)
    if [[ $code == 200 ]]; then
        echo -e "#$frontcontent pushplus 消息发送成功\n"
    else
        if [[ $code == 500 ]]; then
            msg="服务器宕机"
        fi
        [[ ! $msg ]] && msg="访问 API 超时"
        echo -e "#$frontcontent pushplus 消息发送处理失败(${msg})\n"
    fi
}

## hxtrip pushplus 通知 API
hxtrip_pushplus_notify_api() {
    local token=$1
    local topic=$2
    local title=$3
    local content=$4
    local frontcontent=$5
    local content=$(echo -e "$content" | perl -pe '{s|(\")|'\\'\\1|g; s|\n|<br>|g}')
    local url="http://pushplus.hxtrip.com/send"

    local api=$(
        curl -s --noproxy "*" "$url" \
            -X 'POST' \
            -H "Content-Type: application/json" \
            --data-raw "{\"token\":\"$token\",\"title\":\"$title\",\"content\":\"$content\"}"
    )
    code=$(echo $api | perl -pe '{s|.*<code>([\d]+)</code>.*|\1|g}')
    msg=$(echo $api | perl -pe '{s|.*<msg>([\S]+)</msg>.*|\1|g}')
    if [[ $code == 200 ]]; then
        echo -e "#$frontcontent hxtrip pushplus 消息发送成功\n"
    else
        if [[ $code == 500 ]]; then
            msg="服务器宕机"
        fi
        [[ ! $msg ]] && msg="访问 API 超时"
        echo -e "#$frontcontent hxtrip pushplus 消息发送处理失败(${msg})\n"
    fi
}

Notify_to_Public() {
    local title summary content
    title=$1
    summary=$2
    content=$3

    if [[ ${title} ]]; then
        echo -e "# 公告标题：${title}"
    else
        echo -e "# 未填写公告标题"
    fi
    if [[ ${summary} ]]; then
        echo -e "# 公告摘要：${summary}"
    else
        echo -e "# 未填写公告摘要"
    fi
    if [[ ${content} ]]; then
        echo -e "# 公告正文：${content}"
    else
        echo -e "# 未填写公告正文"
    fi
    echo -e ""

    # WxPusher 公告
    if [[ $Filter_Disabled_Variable = true ]]; then
        if [[ $WxPusher_UID_src = 1 ]]; then
            WxPusher_UID_Array=($(def_envs_match JD_COOKIE '"status": 0' remarks | grep -Eo 'UID_\w{28}'))
        elif [[ $WxPusher_UID_src = 2 ]]; then
            WxPusher_UID_Array=($(def_json_match "$dir_scripts/CK_WxPusherUid.json" '"status": 0' Uid | grep -Eo 'UID_\w{28}'))
        fi
    elif [[ $Filter_Disabled_Variable = false ]]; then
        if [[ $WxPusher_UID_src = 1 ]]; then
            WxPusher_UID_Array=($(def_envs_tool JD_COOKIE remarks | grep -Eo 'UID_\w{28}'))
        elif [[ $WxPusher_UID_src = 2 ]]; then
            WxPusher_UID_Array=($(def_json_value "$dir_scripts/CK_WxPusherUid.json" Uid | grep -Eo 'UID_\w{28}'))
        fi
    fi

    if [[ $(echo $WP_APP_TOKEN_ONE | grep -Eo 'AT_(\w{32})') && ${#WxPusher_UID_Array[@]} -gt 0 ]]; then
        uids="$(echo "${WxPusher_UID_Array[*]}" | perl -pe '{s|^|\"|; s| |\",\"|g; s|$|\"|}')"
        WxPusher_notify_api "$WP_APP_TOKEN_ONE" "$uids" "$title" "$summary" "$content"
    else
        if [[ ! $(echo $WP_APP_TOKEN_ONE | grep -Eo 'AT_(\w{32})') ]]; then
            echo -e "# 未填写 WxPusher 应用的 token (WP_APP_TOKEN_ONE)，请检查后重试！"
        fi
        if [[ ${#WxPusher_UID_Array[@]} -eq 0 ]]; then
            echo -e "# 未找到 WxPusher UID，请检查后重试！"
        fi
    fi

    # 企业微信公告
    if [[ $QYWX_AM ]]; then
        QYWX_notify_api "$QYWX_AM" "Shell版公告工具notify2" "$title" "$summary" "$content"
    else
        echo -e "# 未填写企业微信应用的 token (QYWX_AM)，请检查后重试！"
    fi

    # pushplus 公告
    if [[ $PUSH_PLUS_TOKEN && $PUSH_PLUS_USER ]]; then
        pushplus_notify_api "$PUSH_PLUS_TOKEN" "$PUSH_PLUS_USER" "$title" "$content"
    else
        if [[ ! $PUSH_PLUS_TOKEN ]]; then
            echo -e "# 未填写 pushplus 的 token (PUSH_PLUS_TOKEN)，请检查后重试！"
        fi
        if [[ ! $PUSH_PLUS_USER ]]; then
            echo -e "# 未填写 hxtrip pushplus 的群组编码 (PUSH_PLUS_USER)，请检查后重试！"
        fi
    fi

    # hxtrip pushplus 公告
    if [[ $PUSH_PLUS_TOKEN_hxtrip && $PUSH_PLUS_USER_hxtrip ]]; then
        hxtrip_pushplus_notify_api "$PUSH_PLUS_TOKEN_hxtrip" "$PUSH_PLUS_USER_hxtrip" "$title" "$content"
    else
        if [[ ! $PUSH_PLUS_TOKEN_hxtrip ]]; then
            echo -e "# 未填写 hxtrip pushplus 的 token (PUSH_PLUS_TOKEN)，请检查后重试！"
        fi
        if [[ ! $PUSH_PLUS_USER_hxtrip ]]; then
            echo -e "# 未填写 hxtrip pushplus 的群组编码 (PUSH_PLUS_USER_hxtrip)，请检查后重试！"
        fi
    fi
}

echo -e "# 当前版本：$Ver\n"
Notify_to_Public "${NOTICE_TITLE}" "${NOTICE_SUMMARY}" "${NOTICE_CONTENT}"

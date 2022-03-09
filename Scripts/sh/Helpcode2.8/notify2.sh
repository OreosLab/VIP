#!/usr/bin/env bash

## Build 20220222-001-test

## 导入通用变量与函数
dir_shell=/ql/shell
. $dir_shell/share.sh
. $dir_shell/api.sh

# 定义 json 数据查询工具
def_envs_tool() {
    for i in $@; do
        curl -s --noproxy "*" "http://0.0.0.0:5600/api/envs?searchValue=$i" -H "Authorization: Bearer $token" | jq .data | perl -pe "{s|^\[\|\]$||g; s|\n||g; s|\},$|\}\n|g}"
    done
}

def_envs_match() {
    def_envs_tool $1 | grep "$2" | jq -r .$3
}

def_json_match() {
    cat "$1" | perl -pe '{s|^\[\|\]$||g; s|\n||g; s|\},$|\}\n|g}' | grep "$2" | jq -r .$3
}

def_json_value() {
    cat "$1" | perl -pe "{s|^\[\|\]$||g; s|\n||g; s|\},$|\}\n|g}" | grep "$3" | jq -r .$2
}

## WxPusher 通知 API
WxPusher_notify_api() {
    local appToken=$1
    local content=$2
    local summary=$3
    local uids=$4
    local frontcontent=$5
    local url="http://wxpusher.zjiecode.com/api/send/message"

    [[ ${#summary} -gt 100 ]] && local summary="${summary:0:90} ……"

    local api=$(
        curl -s --noproxy "*" "$url" \
            -X 'POST' \
            -H "Content-Type: application/json" \
            --data-raw "{\"appToken\":\"$appToken\",\"content\":\"$content\",\"summary\":\"$summary\",\"contentType\":\"2\",\"uids\":[$uids]}"
    )
    code=$(echo $api | jq -r .code)
    msg=$(echo $api | jq -r .msg)
    if [[ $code == 1000 ]]; then
        echo -e "# WxPusher 消息发送成功(${uids})\n"
    else
        [[ ! $msg ]] && msg="访问 API 超时"
        echo -e "# WxPusher 消息发送处理失败(${msg})\n"
    fi
}

## 企业微信应用通知 API
QYWX_GetToken_api() {
    local corpid="$(echo $QYWX_AM | awk -F ',' '{print $1}')"
    local corpsecret="$(echo $QYWX_AM | awk -F ',' '{print $2}')"
    local url="https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=${corpid}&corpsecret=${corpsecret}"

    local api=$(
        curl -s --noproxy "*" "$url"
    )

    code=$(echo $api | jq -r .errcode)
    msg=$(echo $api | jq -r .errmsg)
    access_token=$(echo $api | jq -r .access_token)
    if [[ $code == 0 ]]; then
        ACCESS_TOKEN=${access_token}
    fi
}

QYWX_notify_api() {
    local corpid="$(echo $QYWX_AM | awk -F ',' '{print $1}')"
    local corpsecret="$(echo $QYWX_AM | awk -F ',' '{print $2}')"
    local userId="$(echo $QYWX_AM | awk -F ',' '{print $3}')"
    local agentid="$(echo $QYWX_AM | awk -F ',' '{print $4}')"
    local thumb_media_id="$(echo $QYWX_AM | awk -F ',' '{print $5}')"
    local title=$1
    local content=$2
    local digest=$3
    local frontcontent=$4
    local url="https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=${ACCESS_TOKEN}"

    if [[ $thumb_media_id ]]; then
        local api=$(
            curl -s --noproxy "*" "$url" \
                -X 'POST' \
                -H "Content-Type: application/json" \
                --data-raw "{\"touser\":\"$userId\",\"msgtype\":\"mpnews\",\"agentid\":\"$agentid\",\"mpnews\":{\"articles\":[{\"title\":\"$title\",\"thumb_media_id\":\"$thumb_media_id\",\"author\":\"ckck2\",\"content\":\"$content\",\"digest\":\"$digest\"}]}}"
        )
    fi

    code=$(echo $api | jq -r .errcode)
    msg=$(echo $api | jq -r .errmsg)
    if [[ $code == 0 ]]; then
        echo -e "# 企业微信应用消息发送成功\n"
    else
        [[ ! $msg ]] && msg="访问 API 超时"
        echo -e "# 企业微信应用消息发送处理失败(${msg})\n"
    fi
}

## pushplus 通知 API
pushplus_notify_api() {
    local token=$1
    local title=$2
    local content=$3
    local topic=$4
    local url="http://www.pushplus.plus/send"

    if [[ ${topic} ]]; then
        local api=$(
            curl -s --noproxy "*" "$url" \
                -X 'POST' \
                -H "Content-Type: application/json" \
                --data-raw "{\"token\":\"$token\",\"title\":\"$title\",\"content\":\"$content\",\"topic\":\"$topic\"}"
        )
    else
        local api=$(
            curl -s --noproxy "*" "$url" \
                -X 'POST' \
                -H "Content-Type: application/json" \
                --data-raw "{\"token\":\"$token\",\"title\":\"$title\",\"content\":\"$content\"}"
        )
    fi

    code=$(echo $api | jq -r .code)
    msg=$(echo $api | jq -r .msg)
    if [[ $code == 200 ]]; then
        echo -e "# pushplus 消息发送成功\n"
    else
        if [[ $code == 500 ]]; then
            msg="服务器宕机"
        fi
        [[ ! $msg ]] && msg="访问 API 超时"
        echo -e "# pushplus 消息发送处理失败(${msg})\n"
    fi
}

## hxtrip pushplus 通知 API
hxtrip_pushplus_notify_api() {
    local token=$1
    local title=$2
    local content=$3
    local topic=$4
    local url="http://pushplus.hxtrip.com/send"

    if [[ ${topic} ]]; then
        local api=$(
            curl -s --noproxy "*" "$url" \
                -X 'POST' \
                -H "Content-Type: application/json" \
                --data-raw "{\"token\":\"$token\",\"title\":\"$title\",\"content\":\"$content\",\"topic\":\"$topic\"}"
        )
    else
        local api=$(
            curl -s --noproxy "*" "$url" \
                -X 'POST' \
                -H "Content-Type: application/json" \
                --data-raw "{\"token\":\"$token\",\"title\":\"$title\",\"content\":\"$content\"}"
        )
    fi

    code=$(echo $api | perl -pe '{s|.*<code>([\d]+)</code>.*|\1|g}')
    msg=$(echo $api | perl -pe '{s|.*<msg>([\S]+)</msg>.*|\1|g}')
    if [[ $code == 200 ]]; then
        echo -e "# hxtrip pushplus 消息发送成功\n"
    else
        if [[ $code == 500 ]]; then
            msg="服务器宕机"
        fi
        [[ ! $msg ]] && msg="访问 API 超时"
        echo -e "# hxtrip pushplus 消息发送处理失败(${msg})\n"
    fi
}

Notify_to_Public() {
    if [[ ${NOTICE_CONTENT} && ${NOTICE_SUMMARY} ]]; then
        echo -e "# 公告标题：${NOTICE_TITLE}"
        echo -e "# 公告摘要：${NOTICE_SUMMARY}"
        echo -e "# 公告正文：${NOTICE_CONTENT}"
        echo -e ""

        local title=$(echo "$NOTICE_TITLE" | perl -pe '{s|(\")|'\\'\\1|g;}')
        local content=$(echo "$NOTICE_CONTENT" | perl -pe '{s|(\")|'\\'\\1|g; s|\n|<br>|g}')
        local summary=$(echo "$NOTICE_SUMMARY" | perl -pe '{s|(\")|'\\'\\1|g; s|\n|<br>|g}')

        # WxPusher 公告
        CK_WxPusherUid_dir="$dir_scripts"
        CK_WxPusherUid_file="CK_WxPusherUid.json"

        if [[ $Filter_Disabled_Variable = true ]]; then
            if [[ $WxPusher_UID_src = 1 ]]; then
                WxPusher_UID_Array=($(def_envs_match JD_COOKIE '"status": 0' remarks | grep -Eo 'UID_\w{28}'))
            elif [[ $WxPusher_UID_src = 2 ]]; then
                WxPusher_UID_Array=($(def_json_match "$CK_WxPusherUid_dir/$CK_WxPusherUid_file" '"status": 0' Uid | grep -Eo 'UID_\w{28}'))
            fi
        elif [[ $Filter_Disabled_Variable = false ]]; then
            if [[ $WxPusher_UID_src = 1 ]]; then
                WxPusher_UID_Array=($(def_envs_tool JD_COOKIE remarks | grep -Eo 'UID_\w{28}'))
            elif [[ $WxPusher_UID_src = 2 ]]; then
                WxPusher_UID_Array=($(def_json_value "$CK_WxPusherUid_dir/$CK_WxPusherUid_file" Uid | grep -Eo 'UID_\w{28}'))
            fi
        fi

        if [[ $(echo $WP_APP_TOKEN_ONE | grep -Eo 'AT_(\w{32})') && ${#WxPusher_UID_Array[@]} -gt 0 ]]; then
            uid="$(echo "${WxPusher_UID_Array[*]}" | perl -pe '{s|^|\"|; s| |\",\"|g; s|$|\"|}')"
            WxPusher_notify_api $WP_APP_TOKEN_ONE "$title<br><br>$content" "$title<br><br>$summary" "$uid"
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
            QYWX_GetToken_api
            if [[ $? = 0 ]]; then
                QYWX_notify_api "$title" "$content" "$summary"
            else
                echo -e "# 未查询到企业微信 应用 Token，请检查后重试！"
            fi
        else
            echo -e "# 未填写企业微信应用的 token (QYWX_AM)，请检查后重试！"
        fi

        # pushplus 公告
        if [[ $PUSH_PLUS_TOKEN && $PUSH_PLUS_USER ]]; then
            pushplus_notify_api $PUSH_PLUS_TOKEN "$NOTICE_TITLE" "$content" $PUSH_PLUS_USER
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
            hxtrip_pushplus_notify_api $PUSH_PLUS_TOKEN_hxtrip "$title" "$content" $PUSH_PLUS_USER_hxtrip
        else
            if [[ ! $PUSH_PLUS_TOKEN_hxtrip ]]; then
                echo -e "# 未填写 hxtrip pushplus 的 token (PUSH_PLUS_TOKEN)，请检查后重试！"
            fi
            if [[ ! $PUSH_PLUS_USER_hxtrip ]]; then
                echo -e "# 未填写 hxtrip pushplus 的群组编码 (PUSH_PLUS_USER_hxtrip)，请检查后重试！"
            fi
        fi
    else
        if [[ ! ${summary} ]]; then
            echo -e "# 未填写公告摘要，请检查后重试！"
        fi
        if [[ ! ${content} ]]; then
            echo -e "# 未填写公告正文，请检查后重试！"
        fi
    fi
}

Notify_to_Public

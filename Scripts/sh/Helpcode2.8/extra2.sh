#!/usr/bin/env bash

## Build 20220302-002-test

## 添加你需要重启自动执行的任意命令，比如 ql repo
## 安装node依赖使用 pnpm install -g xxx xxx
## 安装python依赖使用 pip3 install xxx

dir_shell=/ql/shell
. $dir_shell/share.sh

#检查 node 依赖状态并修复
install_node_dependencies_all() {
    node_dependencies_ori_status() {
        if [[ -n $(echo $(cnpm ls $1) | grep ERR) ]]; then
            return 1
        elif [[ -n $(echo $(cnpm ls $1 -g) | grep ERR) ]]; then
            return 2
        elif [[ $(cnpm ls $1) =~ $1 ]]; then
            return 3
        elif [[ $(cnpm ls $1 -g) =~ $1 ]]; then
            return 4
        fi
    }

    test() {
        for i in $@; do
            node_dependencies_ori_status
            echo -e "$i : $?"
        done
    }

    install_node_dependencie() {
        #        node_dependencies_ori_status $1
        #        if [[ $? = 1 || $? = 2 ]]; then
        #            cnpm uninstall $1
        #        elif [[ $? = 3 ]]; then
        #            cnpm uninstall $1 -g
        #        fi
        #
        #        node_dependencies_ori_status $1
        #        if [[ $? = 4 ]]; then
        #            if [[ $1 = "canvas" ]]; then
        #                apk add --no-cache build-base g++ cairo-dev pango-dev giflib-dev && cnpm install $1 -g
        #            else
        #                cnpm install $1 -g --force
        #            fi
        #        fi

        node_dependencies_ori_status $1
        if [[ $? = 1 ]]; then
            [[ $1 = "canvas" ]] && {
                cnpm uninstall $1
                rm -rf /ql/scripts/node_modules/canvas
                rm -rf /usr/local/lib/node_modules/lodash/canvas
            } || cnpm uninstall $1
        elif [ $? = 2 ]; then
            [[ $1 = "canvas" ]] && {
                cnpm uninstall $1 -g
                rm -rf /usr/local/lib/node_modules/canvas
            } || cnpm uninstall $1 -g
        fi

        node_dependencies_ori_status $1
        if [[ $? != 3 && $? != 4 ]]; then
            [[ $1 = "canvas" ]] && {
                apk add --no-cache build-base g++ cairo-dev pango-dev giflib-dev
                cnpm install $1 -g --force
            } || cnpm install $1 -g --force
        fi
    }

    uninstall_dependencies() {
        for i in $package_name; do
            cnpm uninstall $i
            cnpm uninstall i $i
            cnpm uninstall $i -g
            cnpm uninstall i $i -g
        done
    }

    check_node_dependencies_setup_status() {
        for i in $package_name; do
            cnpm ls $i -g
        done
    }

    [[ ! $(npm get registry | grep "taobao.org") ]] && npm config set registry http://registry.npm.taobao.org
    [[ ! $(npm ls cnpm -g) =~ cnpm && ! $(npm ls cnpm -g) =~ cnpm ]] || [[ $(npm ls cnpm -g) =~ (empty) ]] && npm install -g cnpm
    for i in $package_name; do
        install_node_dependencie $i
    done
    #cnpm update --force
    #cnpm i --legacy-peer-deps
    #cnpm i --package-lock-only
    #cnpm audit fix
    #cnpm audit fix --force
}

# 下载  ql.js sendNotify.js JD_DailyBonus.js 依赖
batch_deps_scripts() {
    # 下载开关，on 改成 off 表示不下载
    switch_status=(
        on
        on
        on
        on
        on
    )

    # 主站链接数组
    host_url_array=(
        https://raw.fastgit.org
        https://raw.githubusercontent.com
    )

    # 筛选主站链接
    define_url() {
        for i in $@; do
            local url="$i"
            local api=$(
                curl -sI --connect-timeout 30 --retry 3 --noproxy "*" -o /dev/null -s -w %{http_code} "$url"
            )
            code=$(echo $api)
            [[ $code == 200 || $code == 301 ]] && echo "$url" && break
        done
    }
    host_url="$(define_url ${host_url_array[@]})"

    scripts_source=(
        $host_url/ccwav/QLScript2/main/ql.js
        $host_url/ccwav/QLScript2/main/sendNotify.js
        $host_url/ccwav/QLScript2/main/JS_USER_AGENTS.js
        $host_url/ccwav/QLScript2/main/USER_AGENTS.js
        $host_url/NobyDa/Script/master/JD-DailyBonus/JD_DailyBonus.js
    )

    ## 文件下载工具
    download_file() {
        get_remote_filesize() {
            local url="$1"
            curl -sI --connect-timeout 30 --retry 3 --noproxy "*" "$url" | grep -i Content-Length | awk '{print $2}'
        }

        get_local_filesize() {
            stat -c %s $1
        }

        get_md5() {
            md5sum $1 | cut -d ' ' -f1
        }

        local url="$1"
        local file_path="$2"
        file="${url##*/}"

        local api=$(
            curl -sI --connect-timeout 30 --retry 3 --noproxy "*" -o /dev/null -s -w %{http_code} "$url"
        )

        code=$(echo $api)
        if [[ $code == 200 || $code == 301 ]]; then
            curl -C - -s --connect-timeout 30 --retry 3 --noproxy "*" "$url" -o $file_path/tmp_$file
            if [[ -f "$file_path/tmp_$file" ]]; then
                if [[ $(get_remote_filesize $url) -eq $(get_local_filesize $file_path/tmp_$file) ]]; then
                    if [[ -f "$file_path/$file" ]]; then
                        [[ "$(get_md5 $file_path/$file)" != "$(get_md5 $file_path/tmp_$file)" ]] && mv -f $file_path/tmp_$file $file_path/$file || rm -rf $file_path/tmp_$file
                    else
                        mv -f $file_path/tmp_$file $2/$file
                    fi
                fi
            fi
        else
            echo "无法链接下载链接，请稍后再试！"
        fi
    }

    for ((i = 0; i < ${#scripts_source[*]}; i++)); do
        { if [[ ${switch_status[i]} = "on" ]]; then download_file ${scripts_source[i]} $dir_config; fi; } &
    done
}

## 选择python3还是node
define_program() {
    local first_param=$1
    if [[ $first_param == *.js ]]; then
        which_program="node"
    elif [[ $first_param == *.py ]]; then
        which_program="python3"
    elif [[ $first_param == *.sh ]]; then
        which_program="bash"
    elif [[ $first_param == *.ts ]]; then
        which_program="ts-node-transpile-only"
    else
        which_program=""
    fi
}

#解析口令
jcommand() {
    for i in ${JD_CODE}; do
        local code=$i
        local url="https://api.jds.codes/jd/jcommand"
        local api=$(
            curl -s -k --connect-timeout 20 --retry 3 --noproxy "*" "${url}" \
                -H "Content-Type: application/json" \
                -d '{"code": "'${code}'"}'
        )

        local code=$(echo $api | jq -r .code)
        if [[ $code == 200 ]]; then
            local title=$(echo $api | jq -r .data.title)
            local userName=$(echo $api | jq -r .data.userName)
            local jumpUrl=$(echo $api | jq -r .data.jumpUrl)
            local activityUrl=$(echo $jumpUrl | perl -pe '{s|.*(http[\S]+.com)(?=/?).*|\1|g}')
            local activityId=$(echo $jumpUrl | perl -pe '{s|.*activityId=([^&]+)(?=&?).*|\1|g}')
            echo -e "活动口令解析结果如下  ："
            echo -e "活动标题     (title) : $title"
            echo -e "口令发起人(userName) : $userName"
            echo -e "活动 ID (activityId) : $activityId"
            echo -e "活动链接(activityUrl): $activityUrl"
            local zdjr_scr="$(find $dir_scripts -type f -name "$ZDJR_SCR" | head -1)"
            if [[ $zdjr_scr ]]; then
                echo -e "开始运行 $zdjr_scr ..."
                export activityId=$activityId
                export activityUrl=$activityUrl
                export jd_zdjr_activityId=$activityId
                export jd_zdjr_activityUrl=$activityUrl
                define_program $zdjr_scr
                $which_program $zdjr_scr
            fi
        fi
    done
}

[[ $JD_CODE ]] && jcommand
[[ $DOWNLOAD_BASIC_JS = "1" ]] && batch_deps_scripts
[[ $FixDependType = "1" ]] && install_node_dependencies_all >/dev/null 2>&1 &

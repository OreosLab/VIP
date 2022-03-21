#!/usr/bin/env bash

## 版本号
Ver="Build 20220319-001-Alpha"

## 导入通用变量与函数
dir_shell=/ql/shell
. $dir_shell/share.sh
#. $dir_shell/api.sh

downloda_repo_file() {
    # 筛选主站链接
    define_url() {
        for i in $@; do
            local url="$i"
            local api=$(
                curl -sI --connect-timeout 30 --retry 3 --noproxy "*" -o /dev/null -s -w %{http_code} "$url"
            )
            code=$(echo $api)
            [[ $code == 200 || $code == 301 ]] && repo_host="$url" && break
        done
    }

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
        local file="${url##*/}"

        local api=$(
            curl -sI --connect-timeout 30 --retry 3 --noproxy "*" -o /dev/null -s -w %{http_code} "$url"
        )

        code=$(echo $api)
        if [[ $code == 200 || $code == 301 ]]; then
            retcode=$code
            curl -C - -s --connect-timeout 30 --retry 3 --noproxy "*" "$url" -o $file_path/tmp_$file
            if [[ -f "$file_path/tmp_$file" ]]; then
                if [[ $(get_remote_filesize $url) -eq $(get_local_filesize $file_path/tmp_$file) ]]; then
                    if [[ -f "$file_path/$file" ]]; then
                        [[ "$(get_md5 $file_path/$file)" != "$(get_md5 $file_path/tmp_$file)" ]] && mv -f $file_path/tmp_$file $file_path/$file || rm -rf $file_path/tmp_$file
                    else
                        mv -f "$file_path/tmp_$file" "$file_path/$file"
                    fi
                fi
            fi
        else
            retcode="1"
        fi
    }

    local ori_link=$1
    local file_path=$2
    local repo_host
    # 主站链接数组
    repo_host_array=(
        https://raw.fastgit.org/
        https://raw.githubusercontent.com/
    )
    define_url ${repo_host_array[@]}
    if [ $repo_host ]; then
        for i in $ori_link; do
            file_link=$(echo $i | perl -pe '{s|(https?://[^/]+/)|'$repo_host'|}')
            download_file $file_link $file_path
        done
    fi
}

ori_link="https://raw.githubusercontent.com/chiupam/JD_Diy/main/shell/bot.sh"

downloda_repo_file "$ori_link" "$dir_root"

if [[ $retcode != 1 ]]; then
    sed -i "s|repo/diybot|repo/dockerbot|g" $dir_root/bot.sh
    . $dir_root/bot.sh
    sed -i "s|repo/diybot|repo/dockerbot|g" $dir_repo/dockerbot/shell/bot.sh
    cp -r $dir_repo/dockerbot/config/botset.json /ql/jbot/set.json
    ql bot
else
    echo "无法链接下载文件，请稍后再试！"
fi

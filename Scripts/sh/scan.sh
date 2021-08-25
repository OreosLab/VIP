#/bin/sh

NOWTIME=$(date +%Y-%m-%d-%H-%M-%S)
i=0

while ((i<=0)); do
    echo "扫描 NINJA 程序是否在线"
    ps -fe|grep ninja|grep -v grep
    if [ $? -ne 0 ]; then
        i=0
        echo $NOWTIME" 扫描结束！NINJA 掉线了不用担心马上重启！"
        cd /ql
        ps -ef|grep ninja|grep -v grep|awk '{print $1}'|xargs kill -9 && rm -rf /ql/ninja && rm -rf /ql/ninja
        git clone https://github.com/MoonBegonia/ninja.git /ql/ninja  ## 拉取仓库
        cd /ql/ninja/backend
        pnpm install  ## 安装局部依赖
        cp .env.example .env  ## 复制环境变量配置文件
        cp sendNotify.js /ql/scripts/sendNotify.js ## 复制通知脚本到青龙容器
        pm2 start
        ps -fe|grep Daemon |grep -v grep 
        if [ $? -ne 1 ]; then
            i=1
            echo $NOWTIME" NINJA 重启完成！"
            curl "https://api.telegram.org/bot1878231691:AAG42gjTy0kQWyFnlUkgWDGXhMlyPl4oW18/sendMessage?chat_id=1565562101&text=NINJA 已重启完成"
        fi
    else
        i=1
        echo $NOWTIME" 扫描结束！NINJA 还在！"
    fi
done

echo "开始扫描机器人是否在线！"
ps -fe|grep jbot|grep -v grep
if [ $? -ne 0 ]; then
    echo $NOWTIME" 扫描结束！不好了不好了机器人掉线了，准备重启！"
    nohup python3 -m jbot >/dev/null 2>&1 &
    echo $NOWTIME"  扫描结束！机器人准备重启完成！"
    curl "https://api.telegram.org/bot1878231691:AAG42gjTy0kQWyFnlUkgWDGXhMlyPl4oW18/sendMessage?chat_id=1565562101&text=扫描结束！机器人准备重启完成！"
else
    echo $NOWTIME" 扫描结束！机器人还在！" 
fi

echo "开始扫描静态解析是否在线！"
ps -fe|grep nginx|grep -v grep
if [ $? -ne 0 ]; then
    echo $NOWTIME" 扫描结束！Nginx 静态解析停止了！准备重启！"
    nginx -c /etc/nginx/nginx.conf
    echo $NOWTIME" Nginx 静态解析重启完成！"
    curl "https://api.telegram.org/bot1878231691:AAG42gjTy0kQWyFnlUkgWDGXhMlyPl4oW18/sendMessage?chat_id=1565562101&text= Nginx 静态解析重启完成！"
else
    echo $NOWTIME"  扫描结束！Nginx 静态解析正常呢！" 
fi

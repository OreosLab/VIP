# 去my.telegram.org获取api_id api_hash千万不要点错成delete账户！！！！
- 刚开始学习使用GITHUB，我是一个菜鸟
- 同样的也是刚开始学习PYTHON
- ~~尝试使用python写一个基于E大的dockerV3的机器人交互~~
- 最新版本为jbot文件夹，以后只更新此文件，欢迎大佬pr
***
- BUG漫天飞
- MAIKA永相随
***
## 使用方法：
- 使用方法
    - ~~将bot.py、bot.json、rebot.sh放入/jd/config文件夹下(旧版本使用方法)~~
    - 在docker内执行`apk add python3`
    - 如需扫码获取cookie及获取图片 需执行`apk add zlib-dev gcc jpeg-dev python3-dev musl-dev freetype-dev`
    - 由于需要安装多个依赖包，建议将清华源设置为默认源`pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple`
    - 执行`pip3 install telethon python-socks[asyncio] pillow qrcode requests prettytable`
    - 或者下载requirements.txt `pip3 install -r requirements.txt`
    - ~~rebot.sh 用于杀死原bot进程，后台启动新进程，建议直接环境搭建好后直接 `bash /jd/config/rebot.sh`~~
    - 下载jbot文件夹 放在、/jd或/ql目录下，下载config/bot.json放在config下，在jd或ql目录下运行 `nohup python3 -m jbot >/dev/null 2>&1 &`
    - 如果需要更换机器人token，需要将bot.session删除后，重新运行 ~~`bash /jd/config/rebot.sh`~~
***
## 主要实现功能：
- 主要功能
    - /a 使用你的自定义快捷按钮
    - /start 开始使用本程序
    - /help 获取命令，可直接发送至botfather
    - /bash 执行bash程序，如git_pull、diy及可执行自定义.sh，例如/bash /jd/config/abcd.sh
    - /node 执行js脚本文件，目前仅支持/scirpts、/config目录下js，直接输入/node jd_bean_change 即可进行执行。该命令会等待脚本执行完，期间不能使用机器人，建议使用snode命令。
    - /cmd 执行cmd命令,例如/cmd python3 /python/bot.py 则将执行python目录下的bot.py
    - /snode 命令可以选择脚本执行，只能选择/jd/scripts目录下的脚本，选择完后直接后台运行，不影响机器人响应其他命令
    - /log 选择查看执行日志
    - /getfile 获取/jd目录下文件
    - /setshort 设置自定义按钮，每次设置会覆盖原设置
    - /getcookie 扫码获取cookie
    - 此外直接发送文件，会让你选择保存到哪个文件夹，如果选择运行，将保存至scripts或者own目录下，并立即运行脚本crontab.list文件会自动更新时间
## todo
- todo:
    - ~~snode忽略非js文件，由于tg最大支持100个按钮，需要进行排除非js文件~~ 已完成
    - ~~V4更新了，还没来得及看，后期新增~~ V4版本已更新
    - ~~扫码获取cookie~~ 采用lof大佬方案
    - ~~上一页下一页功能~~ 已完成
    - 有错误请留言，有需要增加功能的，我可以尝试写
    - 初次新增青龙bot，仅支持基础设置，青龙特性尚未研究，后续可能会更新

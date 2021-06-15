# LXK0301京东签到脚本-自动提交互助码

## 前言
今天24号，刚好是LXK0301助力码清除日期，晚上给忘记了，到中午才发现今天互助码重置。

瞬间感觉错误一个亿，之前就想过要折腾个自动提交互助码的脚本，就是太懒了。今天亡羊补牢，折腾折腾。有兴趣可以用阅读我之前的文章
[QuantumultX-京东签到撸京东豆](https://www.orzlee.com/toss/2020/12/22/quantumultX-jingdong-signin-to-lu-jingdong-bean.html)、[openwrt-docker部署lxk0301京东自动签到脚本](https://www.orzlee.com/toss/2021/02/08/openwrt-docker-deploys-lxk0301-jingdong-automatic-signin-script.html)。

## 安装Telegram-Cli
此安装环境是VPS，openwrt上安装用docker，当然VPS也可以使用docker!

科学上网必备，没有一个良好的网络环境为前提都是白折腾！！！

- docker安装（推荐，省去一大堆麻烦事）：
  镜像地址：ugeek/telegram-cli

  - 安装镜像：
    ``` sh
    docker create --name telegram-cli -e TZ=Asia/Shanghai -v 挂载本地目录:/root/.telegram-cli ugeek/telegram-cli:amd64
    ```
  - 启动docker:
    ``` sh
    docker start telegram-cli
    ```
  - 执行telegram-cli命令行交互（先执行一次登陆，输入telegram注册的手机号码，号码记得加区号。）
    ``` sh
    docker exec -it telegram-cli telegram-cli -N -W
    ```
- 以下为编译安装步骤（docker或者编译二选一即可）：

  - 克隆telegram-cli:
    ``` sh
    cd /root/work/telegram  ### 或者你自己想要存放的目录
    git clone --recursive https://github.com/vysheng/tg.git && cd tg
    ```
  - 编译安装
    ``` sh
    ### ubuntu
    sudo apt-get update
    sudo apt-get -y install libreadline-dev libconfig-dev libssl-dev lua5.2 liblua5.2-dev libevent-dev libjansson-dev libpython-dev make
    ./configure
    make
    ```
    如果编译安装出现如下错误：
    ![telegram-cil-error.png][telegram-cil-error.png]

    解决方法：
    ``` sh
    apt-get install -y libgcrypt20-dev libssl-dev
    ./configure --disable-openssl --prefix=/usr CFLAGS="$CFLAGS -w"
    make
    ```

### 申请Telegram APP Key并且登陆telegram-cli
- 首先到telegram-apps里申请一个telegram App key（登陆时电话号码记得加国际区号）。
  ![telegram-app-login.png][telegram-app-login.png]

- 复制Public keys:
  ![app-key.png][app-key.png]

- 创建一个文件保存Public keys:
  ``` sh
  nano /root/work/telegram/bot_key.pub
  ###鼠标右键粘贴
  ctrl+o ##保存 按完记得敲车键
  ctrl+x ##退出
  ```
- 登陆telegram-cil
  ``` sh
  /root/work/telegram/tg/bin/telegram-cli -k /root/work/telegram/bot_key.pub
  ###输入账号绑定的手机号码，记得加区号
  ###输入telegram App收到的验证码
  ```
  ![telegram-cil-login.png][telegram-cil-login.png]

IOS锁屏就会提示offline,打开手机telegram app就会提示online。

- 测试一下命令：
  telegram-cil频道名称如果有空格用下划线代替。
  发送命令格式`/root/work/telegram/tg/bin/telegram-cli -W -e "msg 频道名称 命令"`
  
  ``` sh
  ### 发送一条统计当前互助码池命令
  /root/work/telegram/tg/bin/telegram-cli -W -e "msg Turing_Lab_Bot /count_activity_codes"
  ```
  
  回显信息比较乱，自己看手机或PC telegram APP Turing_Lab_Bot机器人 消息就好了。

## 编写脚本
把互助码准备好，编写脚本：
``` sh
### 创建一个文件，保存脚本
nano /root/work/telegram/submit_activity_codes.sh
```
2021-05-08 优化加载会话列表，resolve_username 只加载需要发送命令的两个BOT，避免会话太多出现奇奇怪怪的问题。

2021-03-08 优化了定时任务脚本，速度更快，不会中断了，之前的脚本有问题，会经常中断(原因是因为脚本中执行发送消息命令太快-W参数加载消息会话列表没有完成就已经发出命令，导致命令出错！)。

复制以下内容，互助码自己替换，其他活动互助码自己添加（多个互助码用&拼接）：
``` sh
#!/bin/bash

telegramPath=TG Path #记得替换你telegram-cli目录/xxx/tg/bin

(
  echo "resolve_username TuringLabbot"
  echo "resolve_username LvanLamCommitCodebot"
  sleep 5
  ### @Turing_Lab_Bot
  ###京喜财富岛
  echo "msg Turing_Lab_Bot /submit_activity_codes jxcfd 互助码"
  ###京东闪购盲盒
  echo "msg Turing_Lab_Bot /submit_activity_codes sgmh 互助码"
  ###京东环球挑战赛
  echo "msg Turing_Lab_Bot /submit_activity_codes jdglobal 互助码"
  ###惊喜工厂
  echo "msg Turing_Lab_Bot /submit_activity_codes jxfactory 互助码"
  ###东东工厂
  echo "msg Turing_Lab_Bot /submit_activity_codes ddfactory 互助码"
  ###东东萌宠
  echo "msg Turing_Lab_Bot /submit_activity_codes pet 互助码"
  ##种豆得豆
  echo "msg Turing_Lab_Bot /submit_activity_codes bean 互助码"
  ###东东农场
  echo "msg Turing_Lab_Bot /submit_activity_codes farm 互助码"
  ### @Commit_Code_Bot
  ###JD签到领现金 提交助力码
  echo "msg Commit_Code_Bot /jdcash 互助码"
  ###JD签到领现金 提交助力码
  echo "msg Commit_Code_Bot /jdcrazyjoy 互助码"
  echo "safe_quit"
) | ${telegramPath}telegram-cli -D
```
`-D`参数关闭了输出，调试的时候可以删除该参数(虽然没什么用，因为你命令发出去还没有等回显就已经结束命令了)。

docker 用户将最后一行脚本替换成`) | docker exec -i telegram-cli telegram-cli -N`,删除`telegramPath=TG Path #记得替换你telegram-cli目录/xxx/tg/bin`即可

保存脚本
``` sh
ctrl+o ##保存 按完记得敲回车键
ctrl+x ##退出
```
赋予脚本可执行权限
``` sh
chmod +x /root/work/telegram/submit_activity_codes.sh
```
测试的时候记得注释大部分命令，留一到两个就行了，频繁提交小心被Bot Ban号。
``` sh
bash /root/work/telegram/submit_activity_codes.sh
```
看看手机接收到的通知，一般接收到通知无非就是提交成功或助力池已满。

## 添加crontab定时任务
助力池每次清空日期为每月1，8，16，24号，延迟10分钟后执行：
``` sh
crontab -e
10 0 1,8,16,24 * * bash /root/work/telegram/submit_activity_codes.sh
```
## 结语
其他Bot签到什么的可以举一反三。

这下一劳永逸，省的忘记错过一个亿。最近京东活动也比较多，没有助力活动任务很难完成，助力才是京东活动的灵魂。

> 版权属于： orzlee  
> 本文链接： https://www.orzlee.com/toss/2021/02/24/lxk0301-jingdong-signin-scriptautomatic-submission-of-mutual-aid-codes.html  
> 作品采用： 《 署名-非商业性使用-相同方式共享 4.0 国际 (CC BY-NC-SA 4.0) 》许可协议授权


[telegram-cil-error.png]:https://github.com/Oreomeow/VIP/blob/main/Icons/TGbash/telegram-cil-error.png  
[telegram-app-login.png]:https://github.com/Oreomeow/VIP/blob/main/Icons/TGbash/telegram-app-login.png  
[app-key.png]:https://github.com/Oreomeow/VIP/blob/main/Icons/TGbash/app-key.png  
[telegram-cil-login.png]:https://github.com/Oreomeow/VIP/blob/main/Icons/TGbash/telegram-cil-login.png

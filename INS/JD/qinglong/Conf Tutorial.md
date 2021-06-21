# 青龙配置教程


## 简介
- 青龙Bot交互使用 **SuMaiKaDe** 大佬的开源项目 👉 [jddockerbot](https://github.com/Orangemuse/jddockerbot/tree/master),感谢大佬的优质代码




## Q : Bot交互配置


### A : 方式一 (推荐)
直接运行 ql bot 安装命令,安装完成后配置 **/config/bot.json** 文件 (配置bot.json见方式二)

``` sh
docker exec -it [Container Name] ql bot
```



### A : 方式二


#### I. 配置环境依赖 (重点)

1. 添加Python3环境依赖

``` sh
// 首先进入容器内部
docker exec -it QL bash

//  添加python3环境依赖
apk add python3 zlib-dev gcc jpeg-dev python3-dev musl-dev freetype-dev
```


2. 添加jbot环境依赖  
以下的1和2的操作是在**青龙容器**中 (docker exec -it QL bash)  

    **1. 设置pip3默认源**
      - 国内环境 (没有代理，**如果有代理请关闭代理**)
      
      ``` sh
      pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
      ```
   
      - 国外环境 (官方源)
      
      ``` sh
      pip3 config set global.index-url https://pypi.python.org/simple
      ```
      
    **2. 在Docker容器中使用pip安装Package会遇到 (`WARNING: Running pip as root will break packages and permissions. You should install packages reliably by using venv: https://pip.pypa.io/warnings/venv`), 解决方案如下:**
     
      ``` sh
      python3 -m venv tutorial-env

      source tutorial-env/bin/activate

      pip3 install telethon python-socks[asyncio] pillow qrcode requests prettytable
      ```

    运行效果
    ![运行效果][运行效果]


#### II. 配置jbot
配置操作在**宿主机**中

1. 下载 https://github.com/SuMaiKaDe/jddockerbot/tree/master/jbot 目录下的文件到QL容器的jbot映射目录下，如果没有映射jbot目录参考此教程 (👉 [修改Docker容器目录映射](https://www.cnblogs.com/poloyy/p/13993832.html)) 修改目录映射，或者按照此博客《青龙安装教程》重新安装

2. 下载 https://github.com/SuMaiKaDe/jddockerbot/blob/master/config/bot.json 到QL容器的config映射目录下，根据以下操作添加相关参数到bot.json文件中

   A. 申请TG bot : 通过 https://t.me/BotFather ，按照提示创建机器人，获取bot_token，例如：12345677:AAAAAAAAA_a0VUo2jjr__CCCCDDD

   B. 获取user_id : 通过 https://t.me/getmyid_bot 获取

   C. 获取api_id和api_hash : 访问 https://my.telegram.org/ ，使用的TG账号登录 ==> 选择API development tools ==> 选择任意一种应用场景，任意命名，保存
   
   ![jbot][jbot]
   
3. 在 **青龙容器 (docker exec -it QL bash)** 中运行 `nohup python3 -m jbot >/ql/log/bot/bot.log 2>&1 &`


#### III. 重启青龙容器 `docker container restart QL`




## Q ：添加脚本库
![添加脚本库][添加脚本库]

--------------------
[运行效果]: https://github.com/Oreomeow/VIP/blob/main/Icons/qinglong/%E8%BF%90%E8%A1%8C%E6%95%88%E6%9E%9C.png
[jbot]:https://github.com/Oreomeow/VIP/blob/main/Icons/qinglong/jbot.png
[添加脚本库]:https://github.com/Oreomeow/VIP/blob/main/Icons/qinglong/%E6%B7%BB%E5%8A%A0%E8%84%9A%E6%9C%AC%E5%BA%93.png

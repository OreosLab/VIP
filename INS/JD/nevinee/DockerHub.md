## 创建
docker-compose.yml如下  
``` yaml
version: "2.0"
services:
  jd:
    image: nevinee/jd:v4-bot     # 不使用bot则为nevinee/jd:v4
    container_name: jd
    restart: always
    tty: true
    network_mode: bridge
    hostname: jd
    volumes:
      - ./config:/jd/config
      - ./log:/jd/log
      - ./own:/jd/own
      #- ./bot-diy:/jd/jbot/diy  # v4-bot标签特有的，v4标签没有，如果你需要额外添加自己编写的BOT程序请解除注释
    environment: 
      - ENABLE_HANGUP=false  # 是否启用挂机
      - ENABLE_TG_BOT=false  # 是否启用TG BOT，v4-bot标签特有的，v4标签没有
    #security_opt:     #armv7设备请解除这两行注释，注意，这会降低容器的安全性，但不这样做你就无法正常使用容器，cli则为--security-opt seccomp=unconfined
      #- seccomp=unconfined
```

创建好后请阅读映射的`config`目录下的`config.sh`和`crontab.list`，并根据说明修改，保存后立即生效，其中`crontab.list`的cron随时可以修改，不想跑的注释即可。

针对BOT版，如果启用了`ENABLE_TG_BOT`，首次创建并不会启动bot，修改好`config`目录下的`bot.json`后请重启容器。

BOT程序原作者：https://github.com/SuMaiKaDe ，向BOT发送`/start`可获取帮助。

armv7设备的seccomp问题详见 [这里](https://wiki.alpinelinux.org/wiki/Release_Notes_for_Alpine_3.13.0#time64_requirements)。

## 命令
``` sh
docker exec jd jtask   # 运行scripts脚本，运行此命令即可查看用法
docker exec jd otask   # 运行own脚本
docker exec jd mtask   # 运行你自己的脚本，如果某些own脚本识别不出来cron，你也可以自行添加mtask任务
docker exec jd jlog    # 删除旧日志
docker exec jd jup     # 更新所有脚本，up=update，运行 docker exec jd jup -h 可查看帮助
docker exec jd jcode   # 导出所有互助码
docker exec jd jcsv    # 记录豆豆变化情况
```
`jtask` `mtask` `otask`链接的都是同一个脚本，`m=my` `o=own` `j=jd`。三者区分仅用在`crontab.list`中，以区别不同类型任务，手动运行直接`jtask`即可。

## Linux、MacOS、Android Termux如何使用
* 自行安装好依赖`bash perl coreutils git wget crond/cronie node/nodejs npm/yarn`，以及`node`包`pm2`;

* 自行解决并部署好ssh key，配置好ssh config；

* 然后按以下流程处理：
``` sh
git clone -b master git@<你设置的host>:evine/jd_shell.git jd
bash jd/jup.sh
```

* 配置`config/config.sh`，并按照`config/crontab.list`中的命令使用即可，命令`jtask` `otask` `mtask` `jup` `jscv` `jcode` `jlog`，用法说明同docker。

## 搬运自 dockerhub [nevinee/jd](https://registry.hub.docker.com/r/nevinee/jd/)

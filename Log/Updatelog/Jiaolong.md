# Jiaolong
## 07.01
青龙v2.8.0-063

镜像提醒:

1. 2.2镜像已更新，修复上午存在的问题，但是建议都升级到2.8
2. 2.2版本的用户可以更新2.2的镜像，但是此镜像不再维护，7月3日后删除
3. 最新版的用户可以不更新镜像，只要执行过ql update就行
4. 某些大佬，既然能看懂代码，还要去泄露框架的漏洞，同为一个程序员，真是难以苟同
5. 最后请各位务必先让自己ck过期，重新获取。并使用最新的镜像
6. 保护ck，从自己做起

执行以下操作  
-> docker pull whyour/qinglong:2.2.0 (拉取2.2版)  
-> docker pull whyour/qinglong:latest (拉取2.8版，也就是最新版)  
-> 然后删除容器，重启运行容器，任务数据和env数据都不会丢失，唯一就是scripts目录脚本的问题，可以手动拷贝下

## 06.30
青龙v2.8.0-063

重要提醒:

1. 由于2.8.0-063以前的版本有泄露ck的风险，所以务必升级到2.8.0-063最新版，不要再迷恋2.2.0了
2. 强烈建议把青龙里的ck账户都退出登录，或者修改密码重新登录，然后重新获取ck
3. 此风险请务必知晓
4. 对各位造成的不便，敬请谅解

务必执行以下操作  
-> docker exec -it qinglong ql update  
-> docker exec -it qinglong ql update  
-> docker exec -it qinglong ql update  

## 06.23
青龙v2.8.0

助力说明:

1. 助力相关不会内置了，不用再提issue
2. 可以自己添加附件的 [code.sh](https://github.com/Oreomeow/VIP/blob/main/Conf/Qinglong/code.sh) 的定时任务，新建 task code.sh 即可，然后修改 [task_before.sh](https://github.com/Oreomeow/VIP/blob/main/Conf/Qinglong/task_before.sh) (https://t.me/jiaolongwang/120) 中的内容见上条通知
3. code.sh 中的 name_js 如果不一样，自行修改作者前缀
4. ql update 执行后面板打不开的，执行 docker exec -it qinglong nginx -c /etc/nginx/nginx.conf 试试
5. 频道发图文真难受

## 2021.06.21
青龙v2.8.0

使用说明:

1. 不管你昨天执行没执行ql update，今天先执行两次
2. 2.2.0升级的能直接看到所有ck，但是没有环境变量名称，可以选中所有ck，批量修改环境变量名
   新建cookie去环境变量管理添加，名称写JD_COOKIE，值填你自己的cookie，可以写一个或者多个，备注随意
3. 互助功能可实现方法很多
   其中一种就是把以前log目录下，子目录code里的最新的文件内容拷贝到task_before.sh中，最下面添加部分代码，具体参考附件
   还有就是你可以在环境变量管理或者config.sh或者task_before.sh任意文件中export脚本需要的环境变量
4. 并发的脚本需要添加一个参数，比如以前是  task sss.js conc ，如果是京东脚本现在是 task sss.js conc JD_COOKIE，如果是其他的，就是 task sss.js 环境变量名
5. 图片见评论，ql code命令已废弃

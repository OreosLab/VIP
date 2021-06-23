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

## 06.23
青龙v2.8.0

助力说明:

1. 助力相关不会内置了，不用再提issue
2. 可以自己添加附件的 code.sh 的定时任务，新建 task code.sh 即可，然后修改 task_before.sh (https://t.me/jiaolongwang/120) 中的内容见上条通知
3. 频道发图文真难受
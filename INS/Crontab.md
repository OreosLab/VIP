# Linux crontab 相关

## 启动
1. 在系统中有 service 这个命令时：   
这个命令在 red hat 当中常用,有的 linux 发行版本中没有这个命令.
```
service crond start //启动服务
```
```
service crond stop //关闭服务
```
```
service crond restart //重启服务
```
 
2. linux 发行版本没有 service 这个命令时：
```
/etc/init.d/cron stop
```
```
/etc/init.d/cron start
```
 
3. 执行出现 /bin/systemctl 。。。。说明是新版的可用以下命令操作
``` 
/bin/systemctl restart crond.service  #启动服务
```
```
/bin/systemctl reload  crond.service  #重新载入配置
```
```
/bin/systemctl status  crond.service  #查看 crontab 服务状态
```

## 解决crontab执行时间与系统时间不一致的问题
```
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
```

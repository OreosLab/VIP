# 青龙2.2.0-066（禁用自动更新版本）

## 删除 原青龙DOCKER 然后 删除 ql/scripts/node_modules 这个目录(不删除的话 npm不兼容，会报错）

## 然后 重新拉取 老版本不自动更新青龙面版

## 青龙2.2.0-066（禁用自动更新版本）

``` sh
docker run -dit \
-v $PWD/ql/config:/ql/config \
-v $PWD/ql/scripts:/ql/scripts \
-v $PWD/ql/repo:/ql/repo \
-v $PWD/ql/log:/ql/log \
-v $PWD/ql/db:/ql/db \
-p 5700:5700 \
--name qinglong \
--hostname qinglong \
--restart always \
limoe/qinglong:latest
```

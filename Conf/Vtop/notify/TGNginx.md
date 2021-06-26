# elecV2P 使用 TG 通知（TG 反代国内机免翻墙）
none · April 15, 2021
## 一、准备好 TG BOT token 和发送对象的 ID，（如何申请 tg bot 网上搜一下）

1. 原来 @BotFather 创建 BOT 时的 token（格式为 xxxxx:xxxxx-xxxx-xxxx)
2. 在 @getuseridbot 这个 bot 里获取要发送对象的 ID，比如自己的就发`/start`，频道或群组就转发频道或群组中的任意一条消息给这个 bot 就行。
3. 发送对象必须先和 bot 有过对话或 bot 在频道或群组中

## 二、到 cf workers 注册个账号（已有账号可跳过此步骤）

链接：https://dash.cloudflare.com/

右上角可切换为简体中文

注册后点击 workers（如不知道此界面在哪，再次点击上面的这个链接）

![workers][workers]

创建 workers

![create][create]

进入以下界面

![script][script]

1 处可以自定义三级域名，随你喜欢更改

2 处清空，把以下代码替换自己的 TG BOT token 后粘贴进去


```
const whitelist = ["/bot此处替换你的tgtoken"];
const tg_host = "api.telegram.org";


addEventListener('fetch', event => {
  event.respondWith(handleRequest(event.request))
})


function validate(path) {
  for (var i = 0; i < whitelist.length; i++) {
    if (path.startsWith(whitelist[i]))
      return true;
  }
  return false;
}


async function handleRequest(request) {
  var u = new URL(request.url);
  u.host = tg_host;
  if (!validate(u.pathname))
    return new Response('Unauthorized', {
      status: 403
    });
  var req = new Request(u, {
    method: request.method,
    headers: request.headers,
    body: request.body
  });
  const result = await fetch(req);
  return result;
}
```


再点下面的保存并部署。再把上面的1处的网址复制下来，格式为 xxx.xxx.workers.dev

至此 CF workers 工作完成

## 三、在 v2p 通知中进行 TG 通知设定：（路径：Setting - 自定义通知）

![push][push]

地址格式为：https://cfworkers网址/bot此处替换为你的TgToken/

如：https://xxx.xxx.workers.dev/botxxxxx:xxxxx-xxxx-xxxx/

方式为：post

下面的内容格式为：
```
{
 "method": "sendMessage",
 "chat_id": 此处替换为发送对象的ID,
 "text": `$title$\n$body$\n$url$`
}
```
都弄好后点下面的保存，再点上面的“通知相关设置”右边的三角形测试发送。

发送成功即可。



[workers]:https://github.com/Oreomeow/VIP/blob/main/Icons/TGNginx/workers.png
[create]:https://github.com/Oreomeow/VIP/blob/main/Icons/TGNginx/create.png
[script]:https://github.com/Oreomeow/VIP/blob/main/Icons/TGNginx/script.png
[push]:https://github.com/Oreomeow/VIP/blob/main/Icons/TGNginx/push.png

# pushplus
```
{
"token": `xxxxxxxxxxxxxxxxxxxx`,
"title": `$title$`,
"content": `$body$\n$url$`,
"Content-Type": `application/json`
}
```
# telegram
Post

`https://api.telegram.org/botxxxxxxxxxx/`
```
{
  "method": "sendMessage",
  "chat_id": xxxxxxxxxx,
  "text": `$title$\n$body$\n$url$`
}
```
# dingtalk
```
{ 
 "msgtype": "markdown", 
 "markdown": { 
 "title": `$title$`, 
 "text": `$title$ \n> $body$\n$url$`  
 } 
}
```
# server 酱
Post
 
`https://sc.ftqq.com/[SCKEY(登入后可见)].send`
or
`https://sctapi.ftqq.com/SENDKEY.send`
```
{
  "text": `$title$`,
  "desp": `$body$可以随便加点自定义文字[链接]($url$)`
}
```
# notify.js
```
if (typeof $title$ !== "undefined") {
    botNotify($title$, $body$, $url$)
}
```
or
```
if (typeof $title$ !== "undefined") {
    botNotify1($title$, $body$, $url$)
    botNotify2($title$, $body$, $url$)
}
```

and
```
function botNotify(title, body, url) {
if (body=== "undefined"){body=""}
if (url==="undefined"){url=""}
  let req = {
      url: 'https://api.telegram.org/botxxxxxxxxxx/',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8'
      },
      method: 'post',
      data: {
        "method": "sendMessage",
        "chat_id": 'xxxxxxxxxx',
        "text": `${title}\n${body}\n${url}`
      }
    }
  $axios(req).then(res=>{
    console.log('mynotify1 通知结果', res.data)
  }).catch(e=>{
    console.error('mynotify1 通知失败', e.message)
  })
}
```
> 参考：https://github.com/elecV2/elecV2P/blob/master/script/JSFile/notify.js
# elecV2P-dei 官方文档
> https://github.com/elecV2/elecV2P-dei/blob/master/docs/07-feed%26notify.md#%E9%80%9A%E7%9F%A5%E6%96%B9%E5%BC%8F

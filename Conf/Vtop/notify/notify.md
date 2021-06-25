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
# COOKIESJD
```
[
  {
    "userName": "",
    "cookie": "pt_key=;pt_pin=;"
  },
  {
    "userName": "",
    "cookie": "pt_key=;pt_pin=;"
  }
]
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

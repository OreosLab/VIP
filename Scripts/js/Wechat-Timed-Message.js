console.log("⏳ 开始发送微信消息")
$exec('python3 https://raw.githubusercontent.com/Oreomeow/VIP/main/Scripts/py/Wechat-Timed-Message.py', {
  cwd: './script/Shell',
  timeout: 0,
  env: {
    SCKEY: $store.get('SCKEY', 'string'),
    PUSH_PLUS_TOKEN: $store.get('PUSH_PLUS_TOKEN', 'string'),
    PUSH_PLUS_TOPIC: $store.get('PUSH_PLUS_TOPIC', 'string'),
    TITLE: $store.get('TITLE', 'string'),
    MSG: $store.get('MSG', 'string'),
    IMAGE: $store.get('IMAGE', 'string'),
    CONTENT: $store.get('CONTENT', 'string'),
    QYWX_AM: $store.get('QYWX_AM', 'string'),  
  },
  cb(data, error) {
    error ? console.error(error) : console.log(data)
  }
})
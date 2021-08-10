// @grant nodejs
console.log("⏳ 开始执行 EUserv_extend.py")
$exec('python3 https://raw.githubusercontent.com/Oreomeow/VIP/main/Scripts/py/EUserv_extend.py', {
  cwd: 'script/Shell',
  timeout: 0,
  env: {
    EUserv_ID: $store.get('EUserv_ID', 'string'),
    EUserv_PW: $store.get('EUserv_PW', 'string'),
    SCKEY: $store.get('SCKEY', 'string'),
    COOL_PUSH_SKEY: $store.get('COOL_PUSH_SKEY', 'string'),
    COOL_PUSH_MODE: $store.get('COOL_PUSH_MODE', 'string'),
    PUSH_PLUS_TOKEN: $store.get('PUSH_PLUS_TOKEN', 'string'),
    TG_BOT_TOKEN: $store.get('TG_BOT_TOKEN', 'string'),
    TG_USER_ID: $store.get('TG_USER_ID', 'string'),
    TG_API_HOST: $store.get('TG_API_HOST', 'string'),
    WECOMCHAN_DOMAIN: $store.get('WECOMCHAN_DOMAIN', 'string'),
    WECOMCHAN_SEND_KEY: $store.get('WECOMCHAN_SEND_KEY', 'string'),
    WECOMCHAN_TO_USER: $store.get('WECOMCHAN_TO_USER', 'string')
  },
  cb(data, error) {
    error ? console.error(error) : console.log(data)
  }
})
// @grant nodejs
console.log("⏳ 开始执行 EUserv_extend.py")
$exec('python3 https://raw.githubusercontent.com/Oreomeow/VIP/main/Scripts/py/EUserv_extend.py', {
  cwd: 'script/Shell',
  timeout: 0,
  env: {
    USERNAME: $store.get('EUserv_ID', 'string'),
    PASSWORD: $store.get('EUserv_PW', 'string'),
    SCKEY: $store.get('SCKEY'),
    COOL_PUSH_SKEY: $store.get('COOL_PUSH_SKEY'),
    COOL_PUSH_MODE: $store.get('COOL_PUSH_MODE'),
    PUSH_PLUS_TOKEN: $store.get('PUSH_PLUS_TOKEN'),
    TG_BOT_TOKEN: $store.get('TG_BOT_TOKEN'),
    TG_USER_ID: $store.get('TG_USER_ID'),
    TG_API_HOST: $store.get('TG_API_HOST'),
    WECOMCHAN_DOMAIN: $store.get('WECOMCHAN_DOMAIN'),
    WECOMCHAN_SEND_KEY: $store.get('WECOMCHAN_SEND_KEY'),
    WECOMCHAN_TO_USER: $store.get('WECOMCHAN_TO_USER')
  },
  cb(data, error) {
    error ? console.error(error) : console.log(data)
  }
})
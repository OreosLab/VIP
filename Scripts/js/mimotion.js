// @grant nodejs
console.log("⏳ 初始化安装依赖中......")
$exec('pip3 install pytz', {
  cwd: './script/Shell',
  timeout: 0,
  cb(data, error) {
    error ? console.error(error) : console.log(data)
  }
})
console.log("⏳ 开始执行 mimotion.py")
$exec('python3 https://raw.githubusercontent.com/Oreomeow/VIP/main/Scripts/py/mimotion.py', {
  cwd: './script/Shell',
  timeout: 0,
  env: {
    MI_USER: $store.get('MI_USER', 'string'),
    MI_PWD: $store.get('MI_PWD', 'string'),
    STEP: $store.get('STEP','string'),
    PMODE: $store.get('PMODE', 'string'),
    PKEY: $store.get('PKEY', 'string')
  },
  cb(data, error) {
    error ? console.error(error) : console.log(data)
  }
})
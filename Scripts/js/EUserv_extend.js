// @grant nodejs
console.log("⏳ 开始执行 EUserv_tsf.py")
$exec('python3 https://raw.githubusercontent.com/Oreomeow/VIP/main/Scripts/py/EUserv_tsf.py', {
  cwd: 'script/Shell',
  timeout: 0,
  env: {
    USERNAME: $store.get('EUserv_ID', 'string'),
    PASSWORD: $store.get('EUserv_PW', 'string')
  },
  cb(data, error) {
    error ? console.error(error) : console.log(data)
  }
})
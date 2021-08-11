// @grant nodejs
console.log("⏳ 初始化安装依赖中......")
$exec('wget https://raw.githubusercontent.com/Oreomeow/freenom-py/main/requirements.txt -O requirements.txt && pip3 install -r requirements.txt', {
  cwd: './script/Shell',
  timeout: 0,
  cb(data, error) {
    error ? console.error(error) : console.log(data)
  }
})
console.log("⏳ 开始拉取 git 仓库 Oreomeow/freenom-py")
$exec('git clone https://github.com/Oreomeow/freenom-py.git', {
  cwd: './script/Shell',
  timeout: 0,
  cb(data, error) {
    error ? console.error(error) : console.log(data)
  }
})
console.log("⏳ 开始执行 FN_extend.py")
$exec('python3 FN_extend.py', {
  cwd: './script/Shell/freenom-py',
  timeout: 0,
  env: {
    FN_ID: $store.get('FN_ID', 'string'),
    FN_PW: $store.get('FN_PW', 'string'),
    MAIL_USER: $store.get('MAIL_USER', 'string'),
    MAIL_ADDRESS: $store.get('MAIL_ADDRESS', 'string'),
    MAIL_PW: $store.get('MAIL_PW', 'string'),
    MAIL_HOST: $store.get('MAIL_HOST', 'string'),
    MAIL_PORT: $store.get('MAIL_PORT', 'string'),
    MAIL_TO: $store.get('MAIL_TO', 'string'),
  },
  cb(data, error) {
    error ? console.error(error) : console.log(data)
  }
})
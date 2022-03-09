// @grant nodejs
console.log('⏳ 初始化安装推送模块中......');
$exec('wget https://raw.githubusercontent.com/whyour/qinglong/master/sample/notify.py -O notify.py', {
    cwd: './script/Shell',
    timeout: 0,
    cb(data, error) {
        error ? console.error(error) : console.log(data);
    },
});
// 通知填写参考 https://raw.githubusercontent.com/whyour/qinglong/master/sample/config.sample.sh
console.log('⏳ 开始执行 FNplus.py');
$exec('python3 https://raw.githubusercontent.com/Oreomeow/freenom-py/main/FNplus.py', {
    cwd: './script/Shell',
    timeout: 0,
    env: {
        FN_ID: $store.get('FN_ID', 'string'), // Freenom 用户名
        FN_PW: $store.get('FN_PW', 'string'), // Freenom 密码
        BARK: $store.get('BARK', 'string'), // bark 服务，此参数如果以 http 或者 https 开头则判定为自建 bark 服务；secrets 可填
        PUSH_KEY: $store.get('PUSH_KEY', 'string'), // Server 酱的 PUSH_KEY；secrets 可填
        TG_BOT_TOKEN: $store.get('TG_BOT_TOKEN', 'string'), // tg 机器人的 TG_BOT_TOKEN；secrets 可填
        TG_USER_ID: $store.get('TG_USER_ID', 'string'), // tg 机器人的 TG_USER_ID；secrets 可填
        TG_PROXY_IP: $store.get('TG_PROXY_IP', 'string'), // tg 机器人的 TG_PROXY_IP；secrets 可填
        TG_PROXY_PORT: $store.get('TG_PROXY_PORT', 'string'), // tg 机器人的 TG_PROXY_PORT；secrets 可填
        DD_BOT_TOKEN: $store.get('DD_BOT_TOKEN', 'string'), // 钉钉机器人的 DD_BOT_TOKEN；secrets 可填
        DD_BOT_SECRET: $store.get('DD_BOT_SECRET', 'string'), // 钉钉机器人的 DD_BOT_SECRET；secrets 可填
        QYWX_AM: $store.get('QYWX_AM', 'string'), // 企业微信应用的 QYWX_AM；secrets 可填 参考 http://note.youdao.com/s/HMiudGkb
    },
    cb(data, error) {
        error ? console.error(error) : console.log(data);
    },
});

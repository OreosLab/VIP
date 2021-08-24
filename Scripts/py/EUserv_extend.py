# -*- coding: utf8 -*-
import os,re,json,time,requests
from bs4 import BeautifulSoup
'''
Author: cokemine
Modifier: o0oo0ooo0 & Oreo
Date: Tue Aug 10 08:24:30 UTC 2021
cron: 0 10 */7 * *
new Env('EUserv 续期');
------------
环境变量说明
EUserv_ID: 账号    用户名，邮箱也可，多账号用空格分隔，ql 环境变量填写需用回车隔开
EUserv_PW: 密码       密码，同上且与账号一一对应
推送变量看下方注释
------------
依赖模块说明
pip install requests beautifulsoup4 / pip3 install requests beautifulsoup4
'''

# 强烈建议部署在非大陆区域，例如HK、SG等
# 常量命名使用全部大写的方式，可以使用下划线。
EUserv_ID = os.environ.get('EUserv_ID')  # 用户名，邮箱也可
EUserv_PW = os.environ.get('EUserv_PW')  # 密码

# Server酱 http://sc.ftqq.com/?c=code
SCKEY = os.environ.get('SCKEY')  # Server酱的key，无需推送可不填 示例: SCU646xxxxxxxxdacd6a5dc3f6

# 酷推 https://cp.xuthus.cc
COOL_PUSH_SKEY = os.environ.get('COOL_PUSH_SKEY')
# 通知类型 CoolPush_MODE的可选项有（默认send）：send[QQ私聊]、group[QQ群聊]、wx[个微]、ww[企微]
COOL_PUSH_MODE = os.environ.get('COOL_PUSH_MODE')

# PushPlus https://pushplus.hxtrip.com/message
PUSH_PLUS_TOKEN = os.environ.get('PUSH_PLUS_TOKEN')

# Telegram Bot Push https://core.telegram.org/bots/api#authorizing-your-bot
TG_BOT_TOKEN = os.environ.get('TG_BOT_TOKEN')  # 通过 @BotFather 申请获得，示例：1077xxx4424:AAFjv0FcqxxxxxxgEMGfi22B4yh15R5uw
TG_USER_ID = os.environ.get('TG_USER_ID')  # 用户、群组或频道 ID，示例：129xxx206
TG_API_HOST = os.environ.get('TG_API_HOST', 'api.telegram.org')  # 自建 API 反代地址，供网络环境无法访问时使用，网络正常则保持默认

# wecomchan https://github.com/easychen/wecomchan
WECOMCHAN_DOMAIN = os.environ.get('WECOMCHAN_DOMAIN')  # http(s)://example.com/
WECOMCHAN_SEND_KEY = os.environ.get('WECOMCHAN_SEND_KEY')
WECOMCHAN_TO_USER = os.environ.get('WECOMCHAN_TO_USER', '@all')  # 默认全部推送, 对个别人推送可用 User1|User2
# 变量命名使用全部小写的方式，可以使用下划线。
desp = ''  # 不用动


# 函数命名使用全部小写的方式，可以使用下划线。
def print_(info):
    print(info)
    global desp
    desp = desp + info + '\n\n'


def login(username, password) -> (str, requests.session):
    headers = {
        "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) "
                      "Chrome/83.0.4103.116 Safari/537.36",
        "origin": "https://www.euserv.com",
    }
    url = "https://support.euserv.com/index.iphp"
    session = requests.Session()

    sess = session.get(url, headers=headers)
    sess_id = re.findall("PHPSESSID=(\\w{10,100});", str(sess.headers))[0]
    # 访问png
    png_url = "https://support.euserv.com/pic/logo_small.png"
    session.get(png_url, headers=headers)

    login_data = {
        "email": username,
        "password": password,
        "form_selected_language": "en",
        "Submit": "Login",
        "subaction": "login",
        "sess_id": sess_id
    }
    f = session.post(url, headers=headers, data=login_data)
    f.raise_for_status()

    if f.text.find('Hello') == -1 and f.text.find('Confirm or change your customer data here') == -1:
        return '-1', session
    return sess_id, session


def get_servers(sess_id: str, session: requests.session) -> {}:
    d = {}
    url = "https://support.euserv.com/index.iphp?sess_id=" + sess_id
    headers = {
        "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) "
                      "Chrome/83.0.4103.116 Safari/537.36",
        "origin": "https://www.euserv.com"
    }
    f = session.get(url=url, headers=headers)
    f.raise_for_status()
    soup = BeautifulSoup(f.text, 'html.parser')
    for tr in soup.select('#kc2_order_customer_orders_tab_content_1 .kc2_order_table.kc2_content_table tr'):
        server_id = tr.select('.td-z1-sp1-kc')
        if not len(server_id) == 1:
            continue
        flag = True if tr.select('.td-z1-sp2-kc .kc2_order_action_container')[
                           0].get_text().find('Contract extension possible from') == -1 else False
        d[server_id[0].get_text()] = flag
    return d


def renew(sess_id: str, session: requests.session, password: str, order_id: str) -> bool:
    url = "https://support.euserv.com/index.iphp"
    headers = {
        "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) "
                      "Chrome/83.0.4103.116 Safari/537.36",
        "Host": "support.euserv.com",
        "origin": "https://support.euserv.com",
        "Referer": "https://support.euserv.com/index.iphp"
    }
    data = {
        "Submit": "Extend contract",
        "sess_id": sess_id,
        "ord_no": order_id,
        "subaction": "choose_order",
        "choose_order_subaction": "show_contract_details"
    }
    session.post(url, headers=headers, data=data)
    data = {
        "sess_id": sess_id,
        "subaction": "kc2_security_password_get_token",
        "prefix": "kc2_customer_contract_details_extend_contract_",
        "password": password
    }
    f = session.post(url, headers=headers, data=data)
    f.raise_for_status()
    if not json.loads(f.text)["rs"] == "success":
        return False
    token = json.loads(f.text)["token"]["value"]
    data = {
        "sess_id": sess_id,
        "ord_id": order_id,
        "subaction": "kc2_customer_contract_details_extend_contract_term",
        "token": token
    }
    session.post(url, headers=headers, data=data)
    time.sleep(5)
    return True


def check(sess_id: str, session: requests.session):
    print("Checking.......")
    d = get_servers(sess_id, session)
    flag = True
    for key, val in d.items():
        if val:
            flag = False
            print_("ServerID: %s Renew Failed!" % key)
    if flag:
        print_("ALL Work Done! Enjoy")


# Server酱 http://sc.ftqq.com/?c=code
def server_chan():
    data = (
        ('text', 'EUserv续费日志'),
        ('desp', desp)
    )
    response = requests.post('https://sc.ftqq.com/' + SCKEY + '.send', data=data)
    if response.status_code != 200:
        print('Server酱 推送失败')
    else:
        print('Server酱 推送成功')


# 酷推 https://cp.xuthus.cc/
def coolpush():
    c = 'EUserv续费日志\n\n' + desp
    data = json.dumps({'c': c})
    url = 'https://push.xuthus.cc/' + COOL_PUSH_MODE + '/' + COOL_PUSH_SKEY
    response = requests.post(url, data=data)
    if response.status_code != 200:
        print('酷推 推送失败')
    else:
        print('酷推 推送成功')


# PushPlus https://pushplus.hxtrip.com/message
def push_plus():
    data = (
        ('token', PUSH_PLUS_TOKEN),
        ('title', 'EUserv续费日志'),
        ('content', desp)
    )
    url = 'https://pushplus.hxtrip.com/send'
    response = requests.post(url, data=data)
    if response.status_code != 200:
        print('PushPlus 推送失败')
    else:
        print('PushPlus 推送成功')


# Telegram Bot Push https://core.telegram.org/bots/api#authorizing-your-bot
def telegram():
    data = (
        ('chat_id', TG_USER_ID),
        ('text', 'EUserv续费日志\n\n' + desp)
    )
    response = requests.post('https://' + TG_API_HOST + '/bot' + TG_BOT_TOKEN + '/sendMessage', data=data)
    if response.status_code != 200:
        print('Telegram Bot 推送失败')
    else:
        print('Telegram Bot 推送成功')


# wecomchan https://github.com/easychen/wecomchan
def wecomchan():
    response = requests.get(WECOMCHAN_DOMAIN + 'wecomchan?sendkey=' + WECOMCHAN_SEND_KEY + '&msg_type=text' + '&to_user=' +
                            WECOMCHAN_TO_USER + '&msg=' + 'EUserv续费日志\n\n' + desp)
    if response.status_code != 200:
        print('wecomchan 推送失败')
    else:
        print('wecomchan 推送成功')


def main_handler(event, context):
    if not EUserv_ID or not EUserv_PW:
        print_("你没有添加任何账户")
        exit(1)
    user_list = EUserv_ID.strip().split()
    passwd_list = EUserv_PW.strip().split()
    if len(user_list) != len(passwd_list):
        print_("The number of usernames and passwords do not match!")
        exit(1)
    for i in range(len(user_list)):
        print('*' * 30)
        print_("正在续费第 %d 个账号" % (i + 1))
        sessid, s = login(user_list[i], passwd_list[i])
        if sessid == '-1':
            print_("第 %d 个账号登陆失败，请检查登录信息" % (i + 1))
            continue
        servers = get_servers(sessid, s)
        print_("检测到第 {} 个账号有 {} 台VPS，正在尝试续期".format(i + 1, len(servers)))
        for k, v in servers.items():
            if v:
                if not renew(sessid, s, passwd_list[i], k):
                    print_("ServerID: %s Renew Error!" % k)
                else:
                    print_("ServerID: %s has been successfully renewed!" % k)
            else:
                print_("ServerID: %s does not need to be renewed" % k)
        time.sleep(15)
        check(sessid, s)
        time.sleep(5)
    
    # 防止 config.sh export TG_API_HOST="" 的情况
    global TG_API_HOST
    if TG_API_HOST == "":
        TG_API_HOST = 'api.telegram.org'

    # 五个通知渠道至少选取一个
    SCKEY and server_chan()
    COOL_PUSH_MODE and COOL_PUSH_SKEY and coolpush()
    PUSH_PLUS_TOKEN and push_plus()
    TG_BOT_TOKEN and TG_USER_ID and TG_API_HOST and telegram()
    WECOMCHAN_DOMAIN and WECOMCHAN_SEND_KEY and WECOMCHAN_TO_USER and wecomchan()

    print('*' * 30)


if __name__ == '__main__':  # 方便我本地调试
    main_handler(None, None)

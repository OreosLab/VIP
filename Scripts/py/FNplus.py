'''
cron: 25 7 */10 * *
new Env('Freenom 续期消息版');
'''
import os,re,requests,argparse

# 登录地址
LOGIN_URL = 'https://my.freenom.com/dologin.php'

# 域名状态地址
DOMAIN_STATUS_URL = 'https://my.freenom.com/domains.php?a=renewals'

# 域名续期地址
RENEW_DOMAIN_URL = 'https://my.freenom.com/domains.php?submitrenewals=true'

# token 正则
token_ptn = re.compile('name="token" value="(.*?)"', re.I)

# 域名信息正则
domain_info_ptn = re.compile(
    r'<tr><td>(.*?)</td><td>[^<]+</td><td>[^<]+<span class="[^<]+>(\d+?).Days</span>[^&]+&domain=(\d+?)">.*?</tr>',
    re.I)

# 登录状态正则
login_status_ptn = re.compile('<a href="logout.php">Logout</a>', re.I)

# args
parser = argparse.ArgumentParser()
parser.add_argument('-u', '--username', type=str)
parser.add_argument('-p', '--password', type=str)
args = parser.parse_args()
username = args.username
password = args.password

def qlnotify(desp):
    cur_path = os.path.abspath(os.path.dirname(__file__))
    if os.path.exists(cur_path + "/notify.py"):
        try:
            from notify import send
        except:
            print("加载通知服务失败~")
        else:
            send('Freenom 续期', desp)

class FreeNom:
    def __init__(self, username: str, password: str):
        self._u = username
        self._p = password
        self._s = requests.Session()
        self._s.headers.update({
            'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/79.0.3945.130 Safari/537.36'
        })

    def _login(self) -> bool:
        self._s.headers.update({
            'content-type': 'application/x-www-form-urlencoded',
            'referer': 'https://my.freenom.com/clientarea.php'
        })
        r = self._s.post(LOGIN_URL, data={'username': self._u, 'password': self._p})
        return r.status_code == 200

    def renew(self):
        global msg
        msg = ''
        # login
        ok = self._login()
        if not ok:
            msg = 'login failed'
            print(msg)
            return

        # check domain status
        self._s.headers.update({'referer': 'https://my.freenom.com/clientarea.php'})
        r = self._s.get(DOMAIN_STATUS_URL)

        # login status check
        if not re.search(login_status_ptn, r.text):
            msg = 'get login status failed'
            print(msg)
            return

        # page token
        match = re.search(token_ptn, r.text)
        if not match:
            msg = 'get page token failed'
            print(msg)
            return
        token = match.group(1)

        # domains
        domains = re.findall(domain_info_ptn, r.text)

        # renew domains
        for domain, days, renewal_id in domains:
            days = int(days)
            if days < 14:
                self._s.headers.update({
                    'referer': f'https://my.freenom.com/domains.php?a=renewdomain&domain={renewal_id}',
                    'content-type': 'application/x-www-form-urlencoded'
                })
                r = self._s.post(RENEW_DOMAIN_URL, data={
                    'token': token,
                    'renewalid': renewal_id,
                    f'renewalperiod[{renewal_id}]': '12M',
                    'paymentmethod': 'credit'
                })
                result = f'{domain} 续期成功' if r.text.find('Order Confirmation') != -1 else f'{domain} 续期失败'
                print(result)
                msg += result + '\n'
            result = f'{domain} 还有 {days} 天续期'
            print(result)
            msg += result + '\n'

if "FN_ID" in os.environ:
    username = os.environ.get('FN_ID')
if "FN_PW" in os.environ:
    password = os.environ.get('FN_PW')

if not username or not password:
    msg = '你没有添加任何账户'
    print(msg)
    exit(1)
    
user_list = username.strip().split()
passwd_list = password.strip().split()

if len(user_list) != len(passwd_list):
    msg = '账户与密码不匹配'
    print(msg)
    exit(1)
    
for i in range(len(user_list)):
    instance = FreeNom(user_list[i], passwd_list[i])  
    instance.renew()
    qlnotify(msg)

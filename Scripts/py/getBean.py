'''
Author: Chiupam (https://t.me/chiupam)
version: 0.1.5
date: 2021-05-16
update: 1. 删除读取 bot.json 的函数，把原先的功能写进 main() 函数内；
        2. 添加 Telegram Bot 推送功能，默认推送大于10京豆的奖励和错误的 json 包，可关闭；
        3. 解析 get 后返回的数据包，重写函数判断，更好的输出日志（如仍有不能解析的数据包会推送给你的 TgBot，请私发给我即可）；
        4. 读取 bot.json 来启动代理功能，开启代理但使用旧 bot.json 模板会输出警告信息（但未测试过开启代理是否能正确运行程序，自查自纠，今晚熬不住了。。。）
'''


'''
使用说明：（示例命令以名为 jd 的容器编写）
    一、首次执行，或未写入密令文件的
        1. 把 getBean.py 上传到 config 目录内
        2. 禁止使用机器人 cmd 命令执行，请主动在终端中输入命令：docker exec -it jd bash
        3. 终端中输入命令：python /jd/config/getBean.py
        4. 终端中输入登录 Telegram 的电话号码，带国家代码，例如：+1、+852、+86
        5. 在 Telegram 客户端中获取登录验证码，并在终端中输入验证码，（可能还需要输入二次验证码！）
        6. 看到自己的用户名后即代表登录成功，此时按 Ctrl + C 结束脚本，并会在 config 目录下看到新生成的 session.txt 密令文件
        7. 终端中输入命令：nohup /usr/bin/python -u /jd/config/getBean.py >> /jd/log/getBean.log 2>&1 &
    二、非首次执行，或已写入密令文件的
        1. 未开启 cmd 功能的，且终端没有 python 环境的，请在终端输入以下两条命令
            第一条命令：docker exec -it jd bash
            第二条命令：nohup /usr/bin/python -u /jd/config/getBean.py >> /jd/log/getBean.log 2>&1 &
        2. 未开启 cmd 功能的，但终端有 python 环境的，请在终端输入命令
            前端运行（不推荐）：python /jd/config/getBean.py
            后台运行（推荐）：nohup /usr/bin/python -u /jd/config/getBean.py >> /jd/log/getBean.log 2>&1 &
        3. 已开启 cmd 功能的，可在机器人处发送命令
            /cmd nohup python -u /jd/config/getBean.py >> /jd/log/getBean.log 2>&1 &
注意事项：
    1. 切勿删除、泄露 config 目录下的 session.txt 密令文件！
    2. 目前仅支持 v4-bot 且已将个人的 api 填入 bot.json 文件内的用户使用！https://my.telegram.org/
'''
import os, re, json, time


count = 2 # 此部分参考了 178.py
while count:
    try:
        from telethon import TelegramClient, events, connection
        from telethon.sessions import StringSession
        break
    except:
        if count == 2:
            pip = 'pip3'
        else:
            pip = 'pip'
        print(f'检测到没有 telethon 库，开始换源进行安装，将使用 {pip} 命令')
        os.system(f'{pip} install telethon -i https://pypi.tuna.tsinghua.edu.cn/simple')
        count -= 1
        continue
count = 2
while count:
    try:
        import requests
        break
    except:
        if count == 2:
            pip = 'pip3'
        else:
            pip = 'pip'
        print(f'检测到没有 requests 库，开始换源进行安装，将使用 {pip} 命令')
        os.system(f'{pip} install requests -i https://pypi.tuna.tsinghua.edu.cn/simple')
        count -= 1
        continue


# 互助码
def findCookie(docker_file_path):
    config_sh_path = f'{docker_file_path}/config/config.sh'
    cookie_file = f'{docker_file_path}/config/cookie.txt'
    for line in open(config_sh_path, 'r', encoding='utf-8'):
        cookie = re.findall(r'pt_key=([^;]+)(?=);', line, re.DOTALL)
        if cookie != []:
            # code = re.findall(r'"(.*?)"', line, re.DOTALL) # 获取的 cookie 字符串（列表、单元素）
            # if code != []: # 非空元素
            with open(cookie_file, 'a', encoding='utf-8') as f2:
                print(cookie[0], file=f2, end='&') # 写入 cookie 字符串（字符串）
    cookie_file = f'{docker_file_path}/config/cookie.txt'
    with open(cookie_file, 'r', encoding='utf-8') as f:
        cookie_list = f.readline().split('&')[:-1]
        return [cookie_list, cookie_file]


# 初次登录并写入密令
def obtainSession(docker_file_path, api_id, api_hash):
    with TelegramClient(StringSession(), api_id, api_hash) as client:
        with open(f'{docker_file_path}/config/session.txt', 'w', encoding='utf-8') as f:
            print(f'请输入手机号（带国家代码）和验证码登录以获取、写入密令')
            print(client.session.save(), file=f)
            print(f'写入密令后请不要删除、泄露 {docker_file_path}/session.txt 文件')


# 发起 get 网络请求
def getBean(url, Referer):
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.104 Safari/537.36",
        # "Referer": "",
        "Accept-Encoding": "gzip,compress,br,deflate",
        "Cookie": "",
    }
    cookie_list = findCookie(docker_file_path)[0]
    for i in range(len(cookie_list)):
        headers['Cookie'] = cookie_list[i]
        # headers['Referer'] = Referer
        res = requests.get(url, headers=headers).json()
        f = open(f'{docker_file_path}/log/send.txt', 'a', encoding='utf-8')
        if res['code'] == '0':
            followDesc = res['result']['followDesc']
            if followDesc.find('成功') != -1:
                try:
                    m = len(res['result']['alreadyReceivedGifts'])
                    for i in range(m):
                        redWord = res['result']['alreadyReceivedGifts'][i]['redWord']
                        rearWord = res['result']['alreadyReceivedGifts'][i]['rearWord']
                        getBean_log = f"京东账号{i + 1}\n获得 {redWord} {rearWord}"
                except:
                    giftsToast = res['result']['giftsToast'].split(" \n ")[1]
                    getBean_log = f"京东账号{i + 1}\n获得 {giftsToast}"
            elif followDesc.find('已经') != -1:
                giftsToast = res['result']['giftsToast'].split("，")[1]
                getBean_log = f"京东账号{i + 1}\n{followDesc} {giftsToast}"
        else:
            getBean_log = f'【错误】京东账号{i + 1}\n{res}'
        print(getBean_log, file=f)
        print(getBean_log)
    os.remove(findCookie(docker_file_path)[1])


# 计算是否获得大于 10 京豆的奖励
def accountBean(docker_file_path):
    f = open(f'{docker_file_path}/log/send.txt', 'r', encoding='utf-8').readlines()
    for line in f:
        bean_account_line = re.findall(r'获得 [0-9]{2} 京豆', line, re.DOTALL)
        if bean_account_line != []:
            bean_account = int(re.findall(r"\d{2,}",bean_account_line[0])[0])
            return bean_account
        if line.find("'code': '1'") != -1:
            return 20


# 把获得大于 10 京豆的奖励推送到 Telegram Bot
def tgBot(docker_file_path, user_id, bot_token, tg_notify):
    bean_account = accountBean(docker_file_path)
    if bean_account == None:
        os.remove(f'{docker_file_path}/log/send.txt')
        return
    elif tg_notify and bean_account >= 10:
        f = open(f'{docker_file_path}/log/send.txt', 'r', encoding='utf-8').readlines()
        getBean_log = ''.join(f)
        text = f'关注店铺有好礼\n\n{getBean_log}\n\n{getTime()}'
        url = f'https://api.telegram.org/bot{bot_token}/sendMessage'
        data = {
            "chat_id": user_id,
            "text": text,
            "disable_web_page_preview": False
        }
        headers = {'Content-Type': 'application/x-www-form-urlencoded'}
        requests.post(url=url, data=data, headers=headers)
    os.remove(f'{docker_file_path}/log/send.txt')


# 获取系统时间
def getTime():
    return time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())


# 主程序
def main(docker_file_path, Referer, tg_notify):
    bot_json_path = f'{docker_file_path}/config/bot.json'
    with open(bot_json_path, 'r', encoding='utf-8') as f:
        bot_set = json.load(f)
        api_id = bot_set['api_id']
        api_hash = bot_set['api_hash']
        user_id = bot_set['user_id']
        bot_token = bot_set['bot_token']
        proxy = bot_set['proxy']
        proxy_type = bot_set['proxy_type']
        proxy_add = bot_set['proxy_add']
        proxy_port = bot_set['proxy_port']
        try: # 兼容旧版本 bot.json （小丑竟是我自己）
            proxy_user = bot_set['proxy_user']
            proxy_password = bot_set['proxy_password']
        except:
            if proxy:
                print("检测到 bot.json 使用了旧模板，建议使用新的模板")
    if not os.path.isfile(f'{docker_file_path}/config/bot.json'):
        docker_file_path = '/jd'
    if not os.path.isfile(f'{docker_file_path}/config/session.txt'):
        obtainSession(docker_file_path, api_id, api_hash)
    string = open(f'{docker_file_path}/config/session.txt', 'r', encoding='utf-8').read()[:-1]
    if proxy:
        if proxy_user.find('无') != -1 or proxy_user == '':
            proxy = {
                'proxy_type': proxy_type,
                'addr': proxy_add,
                'port': proxy_port
            }
        else:
            proxy = {
                'proxy_type': proxy_type,
                'addr': proxy_add,
                'port': proxy_port,
                'username': proxy_user,
                'password': proxy_password
            }
        client = TelegramClient(StringSession(string), api_id, api_hash, proxy)
    else:
        client = TelegramClient(StringSession(string), api_id, api_hash)
    regex = re.compile(r'[(](https://api\.m\.jd\.com.*?)[)]', re.S)
    # @client.on(events.NewMessage(chats=[-1001425653276])) # 监控我个人的测试频道（他人不要取消注释此行）
    # @client.on(events.NewMessage(chats=[channel_id], from_users=[user_id])) # 监控群组某人
    @client.on(events.NewMessage(chats=[-1001197524983])) # 监控布道场频道
    async def my_event_handler(event):
        url = re.findall(regex, event.message.text)
        if url != []:
            getBean(url[0], Referer)
            tgBot(docker_file_path, user_id, bot_token, tg_notify)
    with client:
        client.loop.run_forever()


# 开始执行主程序
if __name__ == '__main__':
    file_path_list = os.path.realpath(__file__).split('/')[1:]
    docker_file_path = '/' + '/'.join(file_path_list[:-2])
    Referer = '' # 当你需要时，请注释第 98、105 行，并在第 227 行填入对应的链接（正确的链接要求含有 wx483 字符串）
    tg_notify = True # 默认开启 TgBot 推送功能，当你需要取消时，请把 True 改为 False
    main(docker_file_path, Referer, tg_notify)

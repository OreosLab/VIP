"""
Author: ne-21
Modifier: Oreo
Date: Wed Aug 25 12:11:39 UTC 2021
cron: 20 10 * * *
new Env('机场签到');
------------
环境变量说明
airport_url: 签到机场网址，多个网址用英文逗号分割，不要 user 之类的
airport_user: 签到机场登陆邮箱，与网站对应，多个用户用英文逗号分割
airport_pwd: 签到机场登陆密码，与网站对应，多个密码用英文逗号分割
通知变量参考 https://raw.githubusercontent.com/whyour/qinglong/master/sample/notify.py
"""
import os

import requests

requests.packages.urllib3.disable_warnings()


def qlnotify(desp):
    cur_path = os.path.abspath(os.path.dirname(__file__))
    if os.path.exists(cur_path + "/notify.py"):
        try:
            from notify import send
        except Exception:
            print("加载通知服务失败~")
        else:
            send("机场签到", desp)


class SspanelQd(object):
    def __init__(self):
        # 机场地址
        airport_url = os.environ["airport_url"]
        self.base_url = airport_url.split(",")
        # 登录信息
        airport_user = os.environ["airport_user"]
        self.email = airport_user.split(",")
        airport_pwd = os.environ["airport_pwd"]
        self.password = airport_pwd.split(",")

    def checkin(self):
        msgall = ""
        for i in range(len(self.base_url)):
            email = self.email[i].split("@")
            email = email[0] + "%40" + email[1]
            password = self.password[i]

            session = requests.session()

            try:
                # 以下except都是用来捕获当requests请求出现异常时，
                # 通过捕获然后等待网络情况的变化，以此来保护程序的不间断运行
                session.get(self.base_url[i], verify=False)

            except requests.exceptions.ConnectionError:
                msg = self.base_url[i] + "\n\n" + "网络不通"
                msgall = msgall + self.base_url[i] + "\n\n" + msg + "\n\n"
                print(msg)
                continue
            except requests.exceptions.ChunkedEncodingError:
                msg = self.base_url[i] + "\n\n" + "分块编码错误"
                msgall = msgall + self.base_url[i] + "\n\n" + msg + "\n\n"
                print(msg)
                continue
            except Exception:
                msg = self.base_url[i] + "\n\n" + "未知错误"
                msgall = msgall + self.base_url[i] + "\n\n" + msg + "\n\n"
                print(msg)
                continue

            login_url = self.base_url[i] + "/auth/login"
            headers = {
                "User-Agent": "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36",
                "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
            }

            post_data = "email=" + email + "&passwd=" + password + "&code="
            post_data = post_data.encode()
            response = session.post(login_url, post_data, headers=headers, verify=False)

            headers = {
                "User-Agent": "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36",
                "Referer": self.base_url[i] + "/user",
            }

            response = session.post(
                self.base_url[i] + "/user/checkin", headers=headers, verify=False
            )
            msg = (response.json()).get("msg")

            msgall = msgall + self.base_url[i] + "\n\n" + msg + "\n\n"
            print(msg)

            info_url = self.base_url[i] + "/user"
            response = session.get(info_url, verify=False)

        return msgall

    def main(self):
        msg = self.checkin()
        qlnotify(msg)


# 云函数入口


def main_handler(event, context):
    run = SspanelQd()
    run.main()


if __name__ == "__main__":
    run = SspanelQd()
    run.main()

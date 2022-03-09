#!/usr/bin/env python
# -*-coding:utf-8-*-
# by 'hollowman6' from Lanzhou University(兰州大学)
# modified by Oreo

import json
import os
import re
import urllib.parse

import requests

sckey = os.getenv("PUSH_KEY")
pptoken = os.getenv("PUSH_PLUS_TOKEN")
pptopic = os.getenv("PUSH_PLUS_TOPIC")
title = os.getenv("TITLE")
message = os.getenv("MSG")
content = os.getenv("CONTENT")
qywx_am = os.getenv("QYWX_AM")
image = os.getenv("IMAGE")
access_token = ""
errorNotify = ""


if not title:
    raise Exception("未设置 `TITLE[name]` Actions Secret!")


def exwechat_get_access_token():
    url = "https://qyapi.weixin.qq.com/cgi-bin/gettoken"
    params = {"corpid": corpid, "corpsecret": corpsecret}
    resp = requests.get(url, params=params)
    resp.raise_for_status()
    resp_json = resp.json()
    if "access_token" in resp_json.keys():
        return resp_json["access_token"]
    else:
        raise Exception("请检查CORPID和CORPSECRET是否正确！\n" + resp.text)


def exwechat_get_ShortTimeMedia(img_url):
    if img_url:
        media_url = f"https://qyapi.weixin.qq.com/cgi-bin/media/upload?access_token={access_token}&type=file"
        f = requests.get(img_url).content
        r = requests.post(media_url, files={"file": f}, json=True)
        return r.json()["media_id"]
    else:
        return ""


def exwechat_send(title, digest, content):
    url = (
        "https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=" + access_token
    )
    data = {
        "touser": touser,
        "agentid": agentid,
        "safe": 0,
        "enable_id_trans": 0,
        "enable_duplicate_check": 0,
        "duplicate_check_interval": 1800,
    }
    if content:
        data["msgtype"] = "mpnews"
        data["mpnews"] = {
            "articles": [
                {
                    "title": title,
                    "thumb_media_id": exwechat_get_ShortTimeMedia(image),
                    "author": "Hollow Man",
                    "content_source_url": "https://github.com/HollowMan6/Wechat-Timed-Message/actions",
                    "content": content,
                    "digest": digest,
                }
            ]
        }
    else:
        data["msgtype"] = "textcard"
        data["textcard"] = {
            "title": title,
            "description": digest,
            "url": "https://github.com/HollowMan6/Wechat-Timed-Message/actions",
        }
    resp = requests.post(url, data=json.dumps(data))
    resp.raise_for_status()
    return resp


if sckey:
    try:
        host = "https://sctapi.ftqq.com/"
        title = urllib.parse.quote_plus(title.replace("\n", "\n\n"))
        message = urllib.parse.quote_plus(message.replace("\n", "\n\n"))
        res = requests.get(host + sckey + ".send?title=" + title + "&desp=" + message)
        result = json.loads(res.text)
        if result["data"]["errno"] == 0:
            print("Server酱推送成功!")
        else:
            errorNotify += "Server酱推送错误: " + result + "\n"
    except Exception as e:
        print(e)
        errorNotify += "Server酱推送错误!\n"
else:
    print("未设置SERVERCHANSCKEY，尝试使用PushPlus...")

title = os.getenv("TITLE")
message = os.getenv("MSG")

if pptoken:
    try:
        host = "http://www.pushplus.plus/"
        user = ""
        if not message:
            message = title
            title = ""
        title = urllib.parse.quote_plus(title.replace("\n", "<br>"))
        message = urllib.parse.quote_plus(message.replace("\n", "<br>"))
        res = requests.get(
            host
            + "send?token="
            + pptoken
            + "&title="
            + title
            + "&content="
            + message
            + "&template=html&topic="
            + pptopic
        )
        result = res.json()
        if result["code"] == 200:
            print("成功通过PushPlus将结果通知给相关用户!")
        else:
            errorNotify += "PushPlus推送错误: " + result + "\n"
    except Exception as e:
        print(e)
        errorNotify += "PushPlus推送错误!\n"
else:
    print("未设置PPTOKEN！")

title = os.getenv("TITLE")
message = os.getenv("MSG")

qywx_am_ay = re.split(",", qywx_am)
corpid = qywx_am_ay[0]
corpsecret = qywx_am_ay[1]
touser = qywx_am_ay[2]
agentid = qywx_am_ay[3]

if corpid:
    info = ""
    if corpsecret:
        if agentid:
            try:
                access_token = exwechat_get_access_token()
                content = content.replace("\n", "<br>")
                res = exwechat_send(title, message, content)
                result = res.json()
                if result["errcode"] == 0:
                    print("成功通过企业微信将结果通知给用户!")
                else:
                    errorNotify += "企业微信推送错误: " + res.text + "\n"
            except Exception as e:
                print(e)
                errorNotify += "企业微信推送错误!\n"
        else:
            print("未设置AGENTID，无法推送到企业微信！")
    else:
        print("未设置CORPSECRET，无法推送到企业微信！")
else:
    print("未设置CORPID！")

if errorNotify:
    raise Exception(errorNotify)

# -*- coding:utf-8 -*-
"""
cron: 20 0-23/2 * * *
new Env('清理重复任务');
"""

import json
import os
import sys
import time

import requests

ip = "localhost"


def loadSend():
    print("加载推送功能")
    global send
    cur_path = os.path.abspath(os.path.dirname(__file__))
    sys.path.append(cur_path)
    if os.path.exists(f"{cur_path}/deleteDuplicateTasksNotify.py"):
        try:
            from deleteDuplicateTasksNotify import send
        except Exception:
            print("加载通知服务失败~")


headers = {
    "Accept": "application/json",
    "Authorization": "Basic YWRtaW46YWRtaW4=",
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.131 Safari/537.36",
}


def getTaskList():
    t = round(time.time() * 1000)
    url = "http://%s:5700/api/crons?searchValue=&t=%d" % (ip, t)
    response = requests.get(url=url, headers=headers)
    responseContent = json.loads(response.content.decode("utf-8"))
    return responseContent["data"] if responseContent["code"] == 200 else []


def getDuplicate(taskList):
    wholeNames = {}
    duplicateID = []
    for task in taskList:
        if task["name"] in wholeNames:
            duplicateID.append(task["_id"])
        else:
            wholeNames[task["name"]] = 1
    return duplicateID


def getData(duplicateID):
    rawData = "["
    for count, id in enumerate(duplicateID):
        rawData += '"%s"' % id
        if count < len(duplicateID) - 1:
            rawData += ", "
    rawData += "]"
    return rawData


def deleteDuplicateTasks(duplicateID):
    t = round(time.time() * 1000)
    url = "http://%s:5700/api/crons?t=%d" % (ip, t)
    data = json.dumps(duplicateID)
    headers["Content-Type"] = "application/json;charset=UTF-8"
    response = requests.delete(url=url, headers=headers, data=data)
    msg = json.loads(response.content.decode("utf-8"))
    if msg["code"] != 200:
        print(f"出错！，错误信息为：{msg}")
    else:
        print("成功删除重复任务")


def loadToken():
    # cur_path = os.path.abspath(os.path.dirname(__file__))
    # send("当前路径：",cur_path)
    try:
        with open("/ql/config/auth.json", "r", encoding="utf-8") as f:
            data = json.load(f)
    except Exception:
        # pass
        send("无法获取token", "")
    return data["token"]


if __name__ == "__main__":
    print("开始！")
    loadSend()
    # 直接从 /ql/config/auth.json中读取当前token
    token = loadToken()
    # send("成功获取token!","")
    headers["Authorization"] = f"Bearer {token}"
    taskList = getTaskList()
    # 如果仍旧是空的，则报警
    if len(taskList) == 0:
        print("无法获取taskList!")
    duplicateID = getDuplicate(taskList)
    before = "清除前数量为：%d" % len(taskList)
    print(before)
    after = "清除重复任务后，数量为:%d" % (len(taskList) - len(duplicateID))
    print(after)
    if len(duplicateID) == 0:
        print("没有重复任务")
    else:
        deleteDuplicateTasks(duplicateID)
    send("清理成功", "\n%s\n%s" % (before, after))
    # print("清理结束！")

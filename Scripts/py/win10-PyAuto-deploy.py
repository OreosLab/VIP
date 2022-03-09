import json
import os
import signal
import socket
import subprocess
import time
import urllib.request
import winreg
import zipfile
from os import path

import psutil  # 需要安装 pip install  psutil

CREATE_NO_WINDOW = 0x08000000

userport = "8000"  # 自定义代理的端口
sleep = 2  # 自定义进程检测间隔，太大响应不及时，太小费CPU


def getfile():  # 下载 nondanee 的脚本和 node 程序
    codeurl = "https://github.com/nondanee/UnblockNeteaseMusic/archive/master.zip"
    nodeurl = "https://npm.taobao.org/mirrors/node/v14.16.0/node-v14.16.0-win-x86.zip"
    nodex64 = "https://npm.taobao.org/mirrors/node/v14.16.0/node-v14.16.0-win-x64.zip"

    def is64Windows():
        return "PROGRAMFILES(X86)" in os.environ
    if is64Windows():
        nodeurl = nodex64
    if (
        os.path.exists(r".\UnblockNeteaseMusic-master\app.js") == False
        or os.path.exists(r".\UnblockNeteaseMusic-master\node.exe") == False
    ):
        if os.path.exists(r".\code.zip") == False:
            print("正在下载 nondanee 的脚本")
            urllib.request.urlretrieve(codeurl, "code.zip")
        if os.path.exists(r".\node.zip") == False:
            print("正在下载 node 程序")
            urllib.request.urlretrieve(nodeurl, "node.zip")
        if os.path.exists(r".\UnblockNeteaseMusic-master\app.js") == False:
            print("正在解压脚本")
            f = zipfile.ZipFile("code.zip", "r")
            f.extractall(r"./")
            f.close()
        if os.path.exists(r".\UnblockNeteaseMusic-master\node.exe") == False:
            print("正在解压 node.exe")
            nf = zipfile.ZipFile("node.zip", "r")
            for f_name in nf.namelist():
                # print(type(f_name))
                if f_name.endswith("node.exe"):
                    nodefile = f_name
                    # print(nodefile)
                    break
            with open(r"./UnblockNeteaseMusic-master/node.exe", "wb") as ff:
                ff.write(nf.read(nodefile))
            ff.close()
            nf.close()


def netease():  # 获取网易云音乐安装目录
    key = winreg.OpenKeyEx(
        winreg.HKEY_LOCAL_MACHINE,
        r"SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\cloudmusic.exe",
    )
    musicexe = winreg.QueryValue(key, "")
    # print(musicexe)
    print("网易云音乐目录：", musicexe)
    return musicexe


def setconfigfile(setport=userport):  # 通过修改配置文件设置网易云的 http 代理及端口号
    cf_dir = path.expandvars(r"%LOCALAPPDATA%\Netease\CloudMusic\config")
    proxylist = {
        "Proxy": {
            "Type": "http",
            "http": {
                "Host": "127.0.0.1",
                "Password": "",
                "Port": "2333",
                "UserName": "",
            },
        }
    }
    proxylist["Proxy"]["http"]["Port"] = setport
    try:
        with open(cf_dir, "r+") as f:
            config = json.load(f)
    except IOError:
        with open(cf_dir, "w+") as f:
            json.dump(proxylist, f)
        with open(cf_dir, "r+") as f:
            config = json.load(f)
    # print(type(config))#
    # for a,b in config.items():
    # print(a,"=",b)
    # print(config['Proxy'] if '' in config else 'no')
    if "Proxy" not in config:
        config["Proxy"] = proxylist["Proxy"]
    proxy = config.get("Proxy")
    # print(proxy)
    if proxy.get("Type") != "http" or "Type" not in proxy:
        proxy["Type"] = "http"
    proxy["http"] = proxylist["Proxy"]["http"]
    with open(cf_dir, "w+") as f:
        json.dump(config, f, indent=4)


# setconfigfile('8000')


def getip():
    host = "music.163.com"
    ip = socket.gethostbyname(host)
    print("网易云音乐官方服务器 IP：", ip)
    return ip

'''
node运行脚本及参数语法（autoit3)：  $pid=Run($node_exe &' '& "app.js" &" -p "&$dlport&" -f "&$sIP,@WorkingDir&"\UnblockNeteaseMusic-master\",$show)
'''

def run_M_N():
    node_d = os.path.abspath(r".\UnblockNeteaseMusic-master\node.exe")
    node_p = os.path.dirname(node_d)
    os.chdir(node_p)
    # print(node_d)
    # print(os.path.dirname(node_p))
    command = "%s app.js -p %s -f %s" % (node_d, userport, ip)

    subprocess.Popen(command, shell=False, creationflags=CREATE_NO_WINDOW)
    print("成功启动 NODE 代理，命令行：", command)

    subprocess.Popen(netease(), shell=False)
    print("成功启动网易云音乐")


def procressexist(processname="cloudmusic.exe"):  # 检测进程是否健在(默认：网易云音乐）
    time.sleep(sleep)
    pl = psutil.pids()
    try:
        for pid in pl:
            if psutil.Process(pid).name() == processname:
                return True
                break
        else:
            return False
    except:
        return False


def killprocess(processname="node.exe"):  # 根据进程名结束进程（默认：node.exe)
    pl = psutil.pids()
    try:
        for pid in pl:

            if psutil.Process(pid).name() == processname:
                os.kill(pid, signal.SIGABRT)
                print(processname, "已被终结！")
    except:
        return False


getfile()
setconfigfile()
ip = getip()

run_M_N()

while procressexist() and procressexist("node.exe"):
    print("网易云音乐进程和 NODE 进程健在！")
    pass
killprocess()

#!/usr/bin/env python3
# -*- coding: utf8 -*-
'''
Author: Unknown
Modifier: Oreo
Date: Tue Aug 10 22:32:56 CST 2021
cron: 25 20 * * *
new Env('小米改步2');
------------
环境变量说明
MI_USER: 账号      仅支持单手机号
MI_PWD: 密码
STEP: 步数         空或不填则为 18000-25000 之间随机，自定义示例: 18763 或 19000-24000         
MI_API: api 接口
'''
import os,requests,random


phone = os.environ.get('MI_USER')
password = os.environ.get('MI_PWD')
step = os.environ.get('STEP')

if step is None:
    step = int(random.uniform(18000,25000))
    step_array = ''
else:
    step_array = step.split('-')

if len(step_array) == 2:
    step = str(random.randint(int(step_array[0]),int(step_array[1])))
    print(f"已设置为随机步数（{step_array[0]}-{step_array[1]}）")
elif str(step) == '':
    step = int(random.uniform(18000,25000))
 
def main_handler(event, context): 
    url = os.environ.get('MI_API', 'https://run.nanjin1937.com/API/s_xm.php')
    headers = { 
        'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_4_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 QQ/8.8.17.612 V1_IPH_SQ_8.8.17_1_APP_A Pixel/1125 MiniAppEnable SimpleUISwitch/0 StudyMode/0 QQTheme/1102 Core/WKWebView Device/Apple(iPhone X) NetType/4G QBWebViewType/1 WKType/1' 
 
    } 
    data = { 
        'phone':phone, 
        'password':password, 
        'step':step 
    }
    print(step) 
    response = requests.post(url=url,headers=headers,data=data).text 
    print(response) 
 

if __name__ == '__main__':  # 方便我本地调试
    main_handler(None, None)

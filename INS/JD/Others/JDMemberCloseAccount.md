## 利用JDMemberCloseAccount注销京东会员

### 超简单，有手会动脑子就能学会

### 要求

1. 安装Git
2. 安装python3版本，本机安装的是[Python3.8.5](https://www.python.org/downloads/release/python-385/)
3. 选择性安装[PyCharm](https://www.jetbrains.com/pycharm/download/download-thanks.html?platform=windows&amp;code=PCC)



### 安装方法

1. 克隆到本地

    - 在本机任意文件夹内右键鼠标选择`git bash here`

    ```shell
    git clone git@github.com:yqchilde/JDMemberCloseAccount.git
    #没拉下来就用下面的
    git clone https://github.com/yqchilde/JDMemberCloseAccount.git
    ```

    > 不会这一步的可以直接下载压缩包解压，下载压缩包再不会的话Windows用户请点击屏幕右上角的`X`，Mac os用户请点击屏幕左上角的`红色圆点`

2. 安装所需要的包

    - 在克隆仓库下的文件夹内复制粘贴以下命令
    
    ![微信截图_20210520123845](https://cdn.imqimu.cn/typora/202105/20/123916-141117.png)
    
    ```shell
    pip3 install -r requirements.txt
    ```

3. `chrome`请访问`chrome://version/`查看浏览器的版本，然后去 [chromedriver](http://chromedriver.storage.googleapis.com/index.html) 下载对应的版本/系统驱动，放到项目的`drivers`文件夹下面

4. 配置`config.json`

    ```json
    {
        "device": "ios",
        "baidu_app_id": "",
        "baidu_api_key": "",
        "baidu_secret_key": "",
        "baidu_range": [1231,393,1383,412],
        "baidu_delay_time": 5,
        "browserType": "Chrome",
        "headless": false,
        "binary": "",
        "cjy_validation": false,
        "cjy_username": "",
        "cjy_password": "",
        "cjy_soft_id": "",
        "cjy_kind": 9101,
        "tj_validation": false,
        "tj_username": "",
        "tj_password": "",
        "tj_type_id": 19,
        "ws_conn_url": "ws://localhost:5201/subscribe",
        "ws_timeout": 60,
        "selenium_timeout": 30,
        "skip_shops": "",
        "phone_tail_number": "",
        "mobile_cookie": "",
        "users": {}
    }
    ```
   
    <details><summary>碍眼的配置，想看可以点开看看，一般默认就可以</summary><br>
    
    * `device`: 如果是ios设备就填写ios，安卓留空
      
    * `baidu_app_id`: 需要在[百度智能云](https://cloud.baidu.com/) 注册个账号，搜索文字识别项目，创建应用后的`app_id`
      
    * `baidu_api_key`: 需要在[百度智能云](https://cloud.baidu.com/) 注册个账号，搜索文字识别项目，创建应用后的`api_key`
      
    * `baidu_secret_key`: 需要在[百度智能云](https://cloud.baidu.com/) 注册个账号，搜索文字识别项目，创建应用后的`secret_key`
      
    * `baidu_range`: 需要截取的投屏区域的验证码左上角和右下角坐标，顺序依次是 [左x,左y,右x,右y]
    
    * `baidu_delay_time`: 百度OCR识别的延迟时间，如果没识别到就几秒后再次尝试，默认为5
      
    * `browserType`: 浏览器类型
    
    * `headless`: 无头模式，建议默认设置
    
    * `binary`: 可执行路径，如果驱动没有找到浏览器的话需要你手动配置
    
    * `cjy_validation`: 是否开启超级鹰验证图形验证码
    
    * `cjy_username`: 超级鹰账号，仅在 cjy_validation 为 true 时需要设置
    
    * `cjy_password`: 超级鹰密码，仅在 cjy_validation 为 true 时需要设置
    
    * `cjy_soft_id`: 超级鹰软件ID，仅在 cjy_validation 为 true 时需要设置

    * `cjy_kind`: 超级鹰验证码类型，仅在 cjy_validation 为 true 时需要设置，且该项目指定为 `9101`

    * `tj_validation`: 是否开启图鉴验证图形验证码
    
    * `tj_username`: 图鉴账号，仅在 tj_validation 为 true 时需要设置
    
    * `tj_password`: 图鉴密码，仅在 tj_validation 为 true 时需要设置
    
    * `tj_type_id`: 超级鹰验证码类型，仅在 tj_validation 为 true 时需要设置，且该项目指定为 `19`
    
    * `ws_conn_url`: websocket链接地址，不用动
      
    * `ws_timeout`: websocket接收验证码时间超时时间，超时会跳过当前店铺，进行下一个店铺，默认为60秒
    
    * `selenium_timeout`: selenium操作超时时间，超过会跳过当前店铺，进行下一个店铺，默认为30秒
    
    * `skip_shops`: 需要跳过的店铺，需要填写卡包中的完整店铺名称，为了效率没做模糊匹配，多个店铺用逗号隔开
    
    * `phone_tail_number`: 手机后4位尾号，若填写将会校验店铺尾号是否是规定的，不符合就跳过
    
    * `mobile_cookie`: 手机端cookie，是pt_key开头的那个
    
    * `users`: web端cookie，通过add_cookie.py添加
</details>

5.  添加`cookie`

    * web端cookie：请在项目目录下执行`python3 add_cookie.py`， 在打开的浏览器界面登录你的京东，此时你可以看到`config.json`已经有了你的用户信息（**请不要随意泄露你的cookie**）
    * 手机端cookie：在 config.json 中写入 mobile_cookie 项，注意是pt_key开头的那个（请不要随意泄露你的cookie）
      
    
6.  执行主程序

    在项目目录下执行`python3 main.py`，等待执行完毕即可

## websocket服务端运行

下载 [jd_wstool](https://github.com/yqchilde/JDMemberCloseAccount/releases)，选择自己的电脑系统对应的压缩包，解压运行

## 手机端短信如何传递给电脑端

<details><summary>安卓端</summary><br>
用 `Macrodroid监听`，在https://pan.imqimu.cn/E5/APP
下载第三个文件和下载倒数第二个配置文件导入到Macrodroid内

```bash
http://同局域网IP:5201/publish?smsCode=短信验证码

例如：
http://192.168.2.100:5201/publish?smsCode=12345

同局域网IP会在运行 `./jd_wstool 或 jd_wstool.exe` 时提示出来，例如：
listening on http://192.168.2.100:5201
```

![QQ截图20210520162121](https://cdn.imqimu.cn/typora/202105/20/162202-422992.png)

</details>

<details><summary>iOS端</summary><br>
下载 `爱思助手` 使用实时屏幕，使用QQ截图工具获取左上和右下的xy轴坐标，在config.json内配置

![photo_2021-05-22_13-52-39](https://user-images.githubusercontent.com/72058508/119216624-4dd67e80-bb07-11eb-9f1a-a7014d0b8ad1.jpg)

</details>

### 感谢以下作者的相关项目供我瞎逼逼的机会
### 排名不分先后
- [@AntonVanke](https://github.com/AntonVanke/JDBrandMember)
- [@yqchilde](https://github.com/yqchilde/JDMemberCloseAccount)

## 结束了
### 实在不会Windows用户点击浏览器右上角的`×`，Mac用户点击左上角的红色`小圆点`关闭本教程

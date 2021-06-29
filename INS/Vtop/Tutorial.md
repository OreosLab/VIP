# V2P Tutorial
## JD CK 填写指南 
1. 登录 elecV2P 后台，地址为`ip:8100`
2. CK多种填法
### A. BoxJs 填法（之后再补坑）
### B. 直接填法
#### 🍪 小于等于 2 个账号
选择`JSMANAGE`

1. 账号1  
key 填`CookieJD`  
下面空白处即 value 值按下面的格式填写，或者抓到了直接复制粘贴
```
pt_key=xxx;pt_pin=jd_abcxxx123;
```
2. 账号2  
key 填`CookieJD2`  
下面空白处即 value 值按下面的格式填写，或者抓到了直接复制粘贴
```
pt_key=xxx;pt_pin=jd_999xxx00z;
```
#### 🍪 大于 2 个账号
**可以前两个号用上面方式填写，第三个号开始用此方式填写，也可以全部都用此方式填写**  

选择`JSMANAGE`  
key 填`CookiesJD`  
下面空白处即 value 值按下面的 Json 格式填写，多账号以此类推，自行删减

- 方式一：完整版
```
[
    {
        "userName":"BossofJD",
        "cookie":"pt_key=xxx;pt_pin=jd_abcxxx123;"
    },
    {
        "userName":"jd_999xxx00z",
        "cookie":"pt_key=xxx;pt_pin=jd_999xxx00z;"
    },
    {
        "userName":"jd_629xxxt01",
        "cookie":"pt_key=xxx;pt_pin=jd_629xxxt01;"
    }
]
```

or

```
[
    {
        "cookie":"pt_key=xxx;pt_pin=jd_abcxxx123;"
    },
    {
        "cookie":"pt_key=xxx;pt_pin=jd_999xxx00z;"
    },
    {
        "cookie":"pt_key=xxx;pt_pin=jd_629xxxt01;"
    }
]
```
- 方式二：精简版
```
[{"cookie":"pt_key=xxx;pt_pin=jd_abcxxx123;"},{"cookie":"pt_key=xxx;pt_pin=jd_999xxx00z;"},{"cookie":"pt_key=xxx;pt_pin=jd_629xxxt01;"}]

## Version: v2.8.0
## Date: 2021-06-20
## Mod: Build20210731-001
## Update Content: 可持续发展纲要\n1. session管理破坏性修改\n2. 配置管理可编辑config下文件\n3. 自定义脚本改为查看脚本\n4. 移除互助相关

## 上面版本号中，如果第2位数字有变化，那么代表增加了新的参数，如果只有第3位数字有变化，仅代表更新了注释，没有增加新的参数，可更新可不更新

## 在运行 ql repo 命令时，是否自动删除失效的脚本与定时任务
AutoDelCron="true"

## 在运行 ql repo 命令时，是否自动增加新的本地定时任务
AutoAddCron="true"

## ql repo命令拉取脚本时需要拉取的文件后缀，直接写文件后缀名即可
RepoFileExtensions="js py ts"

## 由于github仓库拉取较慢，所以会默认添加代理前缀，如不需要请移除
GithubProxyUrl="https://ghproxy.com/"

## 设置定时任务执行的超时时间，默认1h，后缀"s"代表秒(默认值), "m"代表分, "h"代表小时, "d"代表天
CommandTimeoutTime="3h"

## 设置批量执行任务时的并发数，默认同时执行5个任务
MaxConcurrentNum="20"

## 在运行 task 命令时，随机延迟启动任务的最大延迟时间
## 默认给javascript任务加随机延迟，如 RandomDelay="300" ，表示任务将在 1-300 秒内随机延迟一个秒数，然后再运行，取消延迟赋值为空
RandomDelay=""

## 如果你自己会写shell脚本，并且希望在每次运行 ql update 命令时，额外运行你的 shell 脚本，请赋值为 "true"，默认为true
EnableExtraShell="true"

## 是否自动启动bot，默认不启动，设置为true时自动启动，目前需要自行克隆bot仓库所需代码，存到ql/repo目录下，文件夹命名为dockerbot
AutoStartBot="true"

## 安装bot依赖时指定pip源，默认使用清华源，如不需要源，设置此参数为空
PipMirror="https://pypi.tuna.tsinghua.edu.cn/simple"

## 通知环境变量
## 1. Server酱
## https://sct.ftqq.com
## 下方填写 SCHKEY 值或 SendKey 值
export PUSH_KEY=""

## 2. BARK
## 下方填写app提供的设备码，例如：https://api.day.app/123 那么此处的设备码就是123
export BARK_PUSH=""
## 下方填写推送声音设置，例如choo，具体值请在bark-推送铃声-查看所有铃声
export BARK_SOUND=""
## 下方填写推送消息分组，默认为"QingLong"
export BARK_GROUP="QingLong"

## 3. Telegram 
## 下方填写自己申请@BotFather的Token，如10xxx4:AAFcqxxxxgER5uw
export TG_BOT_TOKEN=""
## 下方填写 @getuseridbot 中获取到的纯数字ID
export TG_USER_ID=""
## Telegram 代理IP（选填）
## 下方填写代理IP地址，代理类型为 http，比如您代理是 http://127.0.0.1:1080，则填写 "127.0.0.1"
## 如需使用，请自行解除下一行的注释
export TG_PROXY_HOST=""
## Telegram 代理端口（选填）
## 下方填写代理端口号，代理类型为 http，比如您代理是 http://127.0.0.1:1080，则填写 "1080"
## 如需使用，请自行解除下一行的注释
export TG_PROXY_PORT=""
## Telegram 代理的认证参数（选填）
export TG_PROXY_AUTH=""
## Telegram api自建反向代理地址（选填）
## 教程：https://www.hostloc.com/thread-805441-1-1.html
## 如反向代理地址 http://aaa.bbb.ccc 则填写 aaa.bbb.ccc
## 如需使用，请赋值代理地址链接，并自行解除下一行的注释
export TG_API_HOST=""

## 4. 钉钉 
## 官方文档：https://developers.dingtalk.com/document/app/custom-robot-access
## 下方填写token后面的内容，只需 https://oapi.dingtalk.com/robot/send?access_token=XXX 等于=符号后面的XXX即可
export DD_BOT_TOKEN=""
export DD_BOT_SECRET=""

## 5. 企业微信机器人
## 官方说明文档：https://work.weixin.qq.com/api/doc/90000/90136/91770
## 下方填写密钥，企业微信推送 webhook 后面的 key
export QYWX_KEY=""

## 6. 企业微信应用
## 参考文档：http://note.youdao.com/s/HMiudGkb
## 下方填写素材库图片id（corpid,corpsecret,touser,agentid），素材库图片填0为图文消息, 填1为纯文本消息
export QYWX_AM=""

## 7. iGot聚合
## 参考文档：https://wahao.github.io/Bark-MP-helper
## 下方填写iGot的推送key，支持多方式推送，确保消息可达
export IGOT_PUSH_KEY=""

## 8. Push Plus
## 官方网站：http://www.pushplus.plus
## 下方填写您的Token，微信扫码登录后一对一推送或一对多推送下面的token，只填 PUSH_PLUS_TOKEN 默认为一对一推送
export PUSH_PLUS_TOKEN=""
## 一对一多推送（选填）
## 下方填写您的一对多推送的 "群组编码" ，（一对多推送下面->您的群组(如无则新建)->群组编码）
## 1. 需订阅者扫描二维码 2、如果您是创建群组所属人，也需点击“查看二维码”扫描绑定，否则不能接受群组消息推送
export PUSH_PLUS_USER=""

## 9. go-cqhttp
## gobot_url 推送到个人QQ: http://127.0.0.1/send_private_msg  群：http://127.0.0.1/send_group_msg 
## gobot_token 填写在go-cqhttp文件设置的访问密钥
## gobot_qq 如果GOBOT_URL设置 /send_private_msg 则需要填入 user_id=个人QQ 相反如果是 /send_group_msg 则需要填入 group_id=QQ群 
## go-cqhttp相关API https://docs.go-cqhttp.org/api
export GOBOT_URL=""
export GOBOT_TOKEN=""
export GOBOT_QQ=""

## 10. 临时屏蔽某个Cookie
## 如果某些 Cookie 已经失效了，但暂时还没法更新，可以使用此功能在不删除该Cookie和重新修改Cookie编号的前提下，临时屏蔽掉某些编号的Cookie
## 多个Cookie编号以半角的空格分隔，两侧一对半角双引号，使用此功能后，在运行js脚本时账户编号将发生变化
## 举例1：TempBlockCookie="2"    临时屏蔽掉 Cookie2
## 举例2：TempBlockCookie="2 4"  临时屏蔽掉 Cookie2 和 Cookie4

## 如果只是想要屏蔽某个 Cookie 不参加某些活动，可以参考下面 case 这个命令的例子来控制
## case $1 in
##     *jd_fruit*)                            # 东东农场活动脚本关键词
##         TempBlockCookie="5"                # Cookie5 不玩东东农场
##         ;;
##     *jd_dreamFactory* | *jd_jdfactory*)    # 京喜工厂和东东工厂的活动脚本关键词
##         TempBlockCookie="2"                # Cookie2 不玩京喜工厂和东东工厂
##         ;;
##     *jd_jdzz* | *jd_joy*)                  # 京喜赚赚和宠汪汪的活动脚本关键词
##         TempBlockCookie="3 7_8 9-10 12~13" # Cookie3 、Cookie7至8、Cookie9至10、Cookie12至13 不玩京东赚赚和宠汪汪
##         ;;
##     *)                                     # 其他活动
##         TempBlockCookie=""                 # 默认为空值，表示其他帐号参加全部活动。填写帐号序号表示临时指定 Cookie 只能参加其他活动
##         ;;
## esac
case $1 in
    *jd_fruit*)
        TempBlockCookie=""
        ;;
    *jd_dreamFactory* | *jd_jdfactory*)
        TempBlockCookie=""
        ;;
    *jd_jdzz* | *jd_joy*)
        TempBlockCookie=""
        ;;
    *)
        TempBlockCookie=""
        ;;
esac

## 其他需要的变量，脚本中需要的变量使用 export 变量名= 声明即可

# 定义每日签到的通知形式
## js脚本每日签到提供3种通知方式，分别为：
## 关闭通知，那么请在下方填入0
## 简洁通知，那么请在下方填入1，其效果见：https://github.com/LXK9301/jd_scripts/blob/master/icon/bean_sign_simple.jpg
## 原始通知，那么请在下方填入2，如果不填也默认为2，内容比较长，这也是默认通知方式
NotifyBeanSign=""

# 定义每日签到每个接口间的延迟时间
## 默认每个签到接口并发无延迟，如需要依次进行每个接口，请自定义延迟时间，单位为毫秒，延迟作用于每个签到接口, 如填入延迟则切换顺序签到(耗时较长)
export JD_BEAN_STOP=""

# 脚本推送控制类环境变量
## 1、京东多合一签到脚本关闭运行结果推送，默认推送，填true表示不推送
export JD_BEAN_SIGN_STOP_NOTIFY=""
## 2、京东多合一签到脚本推送简单结果，默认推送完整版结果，填true表示启用简单推送
export JD_BEAN_SIGN_NOTIFY_SIMPLE="true"
## 3、东东萌宠关闭推送。填写false为不关闭推送，true为关闭推送
export PET_NOTIFY_CONTROL="false"
## 4、京东农场关闭推送。填写false为不关闭推送，true为关闭推送
export FRUIT_NOTIFY_CONTROL="false"
## 5、京东领现金关闭推送。填写false为不关闭推送，true为关闭推送
export CASH_NOTIFY_CONTROL="false"
## 6、京东摇钱树关闭推送。填写false为不关闭推送，true为关闭推送
export MONEYTREE_NOTIFY_CONTROL="true"
## 7、京东点点券关闭推送。填写false为不关闭推送，true为关闭推送
export DDQ_NOTIFY_CONTROL="false"
## 8、京东京东赚赚小程序关闭推送。填写false为不关闭推送，true为关闭推送
export JDZZ_NOTIFY_CONTROL="false"
## 9、宠汪汪兑换京豆关闭推送。填写false为不关闭推送，true为关闭推送
export JD_JOY_REWARD_NOTIFY="false"
## 10、宠汪汪赛跑获胜后是否推送通知。填false为不推送通知消息,true为推送通知消息
export JOY_RUN_NOTIFY="true"
## 11、东东超市兑换奖品是否关闭推送通知。填false为不关闭推送,true为关闭推送
export MARKET_REWARD_NOTIFY="false"
## 12、京喜财富岛控制是否运行脚本后通知。输入true为通知,不填则为不通知
export CFD_NOTIFY_CONTROL=""
## 13、京喜农场岛控制是否运行脚本后通知。0=只通知成熟;1=本次获得水滴>0;2=任务执行;3=任务执行+未种植种子
export JXNC_NOTIFY_LEVEL="3"

# 功能配置类环境变量
## 1、京东领现金红包兑换京豆开关。false为不换,true为换(花费2元红包兑换200京豆，一周可换四次)，默认为false
export CASH_EXCHANGE="false"
## 2、宠汪汪喂食数量。可以填的数字0,10,20,40,80,其他数字不可
export JOY_FEED_COUNT="80"
## 3、宠汪汪帮好友喂食。默认 "false" 不会自动给好友的汪汪喂食，如想自动喂食，请修改为 "true"
export JOY_HELP_FEED="true"
## 4、宠汪汪是否赛跑(默认参加双人赛跑)。false为不跑,true为跑
export JOY_RUN_FLAG="true"
## 5、宠汪汪参加什么级别的赛跑。可选数字为2,10,50，
## 当JOY_RUN_FLAG不设置或设置为 "true" 时生效
## 可选值：2,10,50，其他值不可以。其中2代表参加双人PK赛，10代表参加10人突围赛，50代表参加50人挑战赛，不填时默认为2
## 各个账号间请使用 & 分隔，比如：JOY_TEAM_LEVEL="2&2&50&10"
## 如果您有5个账号但只写了四个数字，那么第5个账号将默认参加2人赛，账号如果更多，与此类似
export JOY_TEAM_LEVEL="2&2&50&10"
## 6、宠汪汪赛跑自己账号内部互助。输入true为开启内部互助
export JOY_RUN_HELP_MYSELF="true"
## 7、宠汪汪积分兑换多少京豆。目前可填值为20或者500,脚本默认0,0表示不兑换京豆
export JD_JOY_REWARD_NAME="500"
## 8、东东超市兑换京豆数量。目前可输入值为20或者1000，或者其他商品的名称,例如碧浪洗衣凝珠
export MARKET_COIN_TO_BEANS="超值京豆包"
## 9、东东超市是否参加pk。true表示参加,false表示不参加
export JOIN_PK_TEAM="true"
## 10、东东超市是否用金币抽奖。true表示抽奖,false表示不抽奖
export SUPERMARKET_LOTTERY="true"
## 11、东东农场是否使用水滴换豆卡。true表示换,false表示不换
export FRUIT_BEAN_CARD="true"
## 12、是否取关商品。环境变量内容的意思依次是是否取关全部商品(0表示一个都不),是否取关全部店铺数(0表示一个都不),遇到此商品不再进行取关,遇到此店铺不再进行取关
export UN_SUBSCRIBES="300,300,,"
## 12、jd_unsubscribe这个任务是用来取关每天做任务关注的商品和店铺，默认在每次运行时取关20个商品和20个店铺
### 如果取关数量不够，可以根据情况增加，还可以设置 jdUnsubscribeStopGoods 和 jdUnsubscribeStopShop 
### 商品取关数量
export goodPageSize="30"
### 店铺取关数量
export shopPageSize="60"
### 遇到此商品不再取关此商品以及它后面的商品，需去商品详情页长按拷贝商品信息
export jdUnsubscribeStopGoods=""
### 遇到此店铺不再取关此店铺以及它后面的店铺，请从头开始输入店铺名称
export jdUnsubscribeStopShop=""
## 13、疯狂的JOY循环助力开关。true表示循环助力,false表示不循环助力，默认不开启循环助力
export JDJOY_HELPSELF="true"
## 14、疯狂的JOY京豆兑换。0表示不换,其他按可兑换数填写。目前最小2000
export JDJOY_APPLYJDBEAN="2000"
## 15、疯狂的JOY购买joy等级。如需要使用请自行解除注释，可购买等级为 "1~30"
export BUY_JOY_LEVEL=""
## 16、摇钱树是否卖出金果。true卖出，false不卖出，默认false
export MONEY_TREE_SELL_FRUIT="true"
## 17、东东工厂心仪商品。
export FACTORAY_WANTPRODUCT_NAME=""
## 18、东东工厂控制哪个京东账号不运行此脚本。多个使用&连接
export JDFACTORY_FORBID_ACCOUNT=""
## 19、京喜工厂控制哪个京东账号不运行此脚本。多个使用&连接
export DREAMFACTORY_FORBID_ACCOUNT=""
## 20、lxk0301脚本是否加购。如加设置true
export PURCHASE_SHOPS="true"
## 21、京喜工厂拼团瓜分电力活动的activeId（当前需抓包替换或去群里求别人分享）
export TUAN_ACTIVEID=""
## 22、京东UA。点点券脚本运行环境变量
export JD_USER_AGENT=""
## 23、京东试用jd_try相关环境变量
### 控制每次获取商品数量，默认12
export JD_TRY_PAGE_SIZE=""
### 商品分类，以 @ 隔开，示例：家用电器@手机数码@电脑办公@家居家装
export JD_TRY_CIDS_KEYS=""
### 试用类型，以 @ 隔开，示例：免费试用@闪电试
export JD_TRY_TYPE_KEYS=""
### 过滤试用商品关键字，以 @ 隔开(默认内置了很多关键字，建议使用默认)
export JD_TRY_GOOD_FILTERS=""
### 试用商品最低价格
export JD_TRY_MIN_PRICE=""
### 试用商品最多提供数量（过滤垃圾商品）
export JD_TRY_MAX_SUPPLY_COUNT=""

# 阿道夫部分环境变量
## 1、阿道夫脚本加购开关，填true加购
export ADOLF_ADDSKU="true"
## 2、阿道夫脚本入会开关，填true入会
export ADOLF_MARTIN="true"

# zoopanda 部分环境变量
## 1、zoopanda 与粽不同入会
export ZOO_OPENCAD="true"
## 2、zoopanda 与粽不同加购
export ZOO_ADD2CART="true"

# 龙猪猪环境变量
## 京豆雨通知，填写true为不关闭推送，false为关闭推送
export RAIN_NOTIFY_CONTROL="false"
## 整点京豆雨RRA
export SUPER_RAIN_RRA=""
## 半点京豆雨RRA
export HALF_RAIN_RRA=""

# 柠檬（胖虎部分环境变量）
## 1、京喜工厂抢茅台
### 自定义商品变量
export shopid="1598"   ##你要商品ID 冰箱
export shopid1="1607"  ##你要商品ID 茅台
## 2、推一推
### 入口：极速版-赚金币 
### 分享到QQ查看邀请码，packetId就是
### 自定义变量
export tytpacketId=""
## 3、拆红包
export chbpacketId=""
## 4、是兄弟就砍我
### 是兄弟就来砍我脚本要参加砍价的商品ID
export actId=""
export actId1=""
export actId2=""
export actId3=""
export actId4=""
### 是兄弟就来砍我脚本要要参加砍价的邀请码
export packetId="" 
## 5、是兄弟就砍我2
### 惊喜欢乐砍 自定义变量 入口：京喜APP-我的-惊喜欢乐砍
export launchid="" ##你的邀请码
### 第一次参加变量设置为true查看商品ID，填写商品ID后自动获取邀请码邀请；如果只助力，变量设置为false
export first="false"
export active="" ##商品ID
## 6、赚金币
### 入口：极速版-百元生活费-赚金币-邀请好友
### 第一次运行可不填写邀请码，运行一次查看自己的邀请码
export InviterPin="" ##你的邀请码
## 7、0元砍价，入口：京东-我的-0元砍价
### 使用教程：
### 第一步，运行脚本一次日志查看商品ID
### 获取你要砍价的商品ID后变量填写
export skuId="" ##这里填获取的商品ID
### 第二步，再运行一次日志查看商品activityId变量填写
export activity="" ##这里填获取的商品activityId
## 8、邀请有礼  
### 自定义邀请码环境变量
export yqm="" ##你的邀请码
## 9、全民挖现金
### 入口：京东-我的-全民挖现金
### 运行一次查看邀请码 变量你的邀请码 
export shareCode=""
## 10、省钱大赢家本期活动ID
export redEnvelopeId="" 
## 11、省钱大赢家邀请码
export inviter=""
## 12、签到领现金添加变量方式
## 自行添加变量设置邀请码 格式如下 默认10个
export cashinviteCode=""
export cashinviteCode2=""
export cashinviteCode3=""
## 13、大老板农场 新增自定义变量通知开关。true通知打开，false为关闭
export dlbtz="true"
## 14、零食街自动兑换变量
### 自行取消注释和注释
##export ljsdh="jdAward1" ##兑换5豆
##export ljsdh="jdAward2" ##兑换10豆
export ljsdh="jdAward3" ##兑换100豆
##export ljsdh="jdAward4" ##兑换牛奶

# curtinlv 环境变量
## 1、赚京豆
### 助力账号，填写pt_pin或用户名的值，如 zlzh = ['aaaa','xxxx','yyyy'] ，支持ENV
export zlzh="$(echo $JD_COOKIE | sed "s/&/ /g; s/\S*pt_pin=\([^;]\+\);\S*/\'\1\',/g; s/^/[/; s/$\|,$/]/;" | awk 'BEGIN{for(i=0;i<10;i++)hex[i]=i;hex["A"]=hex["a"]=10;hex["B"]=hex["b"]=11;hex["C"]=hex["c"]=12;hex["D"]=hex["d"]=13;hex["E"]=hex["e"]=14;hex["F"]=hex["f"]=15;}{gsub(/\+/," ");i=$0;while(match(i,/%../)){;if(RSTART>1);printf"%s",substr(i,1,RSTART-1);printf"%c",hex[substr(i,RSTART+1,1)]*16+hex[substr(i,RSTART+2,1)];i=substr(i,RSTART+RLENGTH);}print i;}')"  ## 支持中文用户名
## 2、全民抢京豆
export qjd_zlzh="$(echo $JD_COOKIE | sed "s/&/ /g; s/\S*pt_pin=\([^;]\+\);\S*/\'\1\',/g; s/^/[/; s/$\|,$/]/;" | awk 'BEGIN{for(i=0;i<10;i++)hex[i]=i;hex["A"]=hex["a"]=10;hex["B"]=hex["b"]=11;hex["C"]=hex["c"]=12;hex["D"]=hex["d"]=13;hex["E"]=hex["e"]=14;hex["F"]=hex["f"]=15;}{gsub(/\+/," ");i=$0;while(match(i,/%../)){;if(RSTART>1);printf"%s",substr(i,1,RSTART-1);printf"%c",hex[substr(i,RSTART+1,1)]*16+hex[substr(i,RSTART+2,1)];i=substr(i,RSTART+RLENGTH);}print i;}')"  ## 支持中文用户名
## 3、签到领现金助力
export cash_zlzh="$(echo $JD_COOKIE | sed "s/&/ /g; s/\S*pt_pin=\([^;]\+\);\S*/\'\1\',/g; s/^/[/; s/$\|,$/]/;" | awk 'BEGIN{for(i=0;i<10;i++)hex[i]=i;hex["A"]=hex["a"]=10;hex["B"]=hex["b"]=11;hex["C"]=hex["c"]=12;hex["D"]=hex["d"]=13;hex["E"]=hex["e"]=14;hex["F"]=hex["f"]=15;}{gsub(/\+/," ");i=$0;while(match(i,/%../)){;if(RSTART>1);printf"%s",substr(i,1,RSTART-1);printf"%c",hex[substr(i,RSTART+1,1)]*16+hex[substr(i,RSTART+2,1)];i=substr(i,RSTART+RLENGTH);}print i;}')"  ## 支持中文用户名
## 4、京喜工厂开团助力 for Python
### 支持指定账号开团，跑1次脚本默认开3次团，如未指定账号默认给账号一开团。
### 变量ENV 指定开团账号。可填用户名 或 pt_pin 的值。示例：export jxgc_kaituan="用户1&用户2"
export jxgc_kaituan="$(echo $JD_COOKIE | sed "s/&/ /g; s/\S*pt_pin=\([^;]\+\)\S*;/\1/g; s/ /\&/g;" | awk 'BEGIN{for(i=0;i<10;i++)hex[i]=i;hex["A"]=hex["a"]=10;hex["B"]=hex["b"]=11;hex["C"]=hex["c"]=12;hex["D"]=hex["d"]=13;hex["E"]=hex["e"]=14;hex["F"]=hex["f"]=15;}{gsub(/\+/," ");i=$0;while(match(i,/%../)){;if(RSTART>1);printf"%s",substr(i,1,RSTART-1);printf"%c",hex[substr(i,RSTART+1,1)]*16+hex[substr(i,RSTART+2,1)];i=substr(i,RSTART+RLENGTH);}print i;}')"  ## 支持中文用户名
## 5、入会开卡
### int，入会送豆满足此值，否则不入会
export openCardBean="30"
### 布尔值，是否记录符合条件的shopid(默认True)
export record="true"
### 布尔值， True:仅记录，不入会(默认False)
export onlyrecord="false"
### 布尔值，开启记忆功能，接力上一次异常中断位置继续。(默认yes)
export memory="false"
### 布尔值，True：只打印部分日志 False:打印所有日志
export printlog="true"
### Float，限制速度，单位秒，如果请求过快报错适当调整0.5秒以上
export sleepNum="0.5"
### 布尔值，True:使用作者远程仓库更新的id，False：使用本地shopid.txt的id
export isRemoteSid="true"
## 6、东东超市商品兑换
### 填写商品名字，兼容模糊关键词
export coinToBeans='京豆包'
### 多账号并发，默认开启 True，关闭 False
export blueCoin_Cc='True'
### 轮次
export startMaxNum="30"
### 多线程并发，相当于每秒点击兑换次数...适当调整，手机会发烫
export dd_thread="30"
### 开始抢兑时间
export starttime="23:59:59.00000000"
### 结束时间
export endtime="00:00:30.00000000"

# Wenmoux 部分环境变量 
## 1、QQ星系牧场自动兑换20豆
export Cowexchange="true"
## 2、欧洲狂欢杯兑换兑换豆子，填38豆子，填39e卡
export Cupexid="39"
## 3、10秒阅读
### 填写自己CK
export Readck=""
### 填写自己设备UA
export Read10UA=""
### 填true推送消息，默认不推送
export jrpush=""

# smiek2221 环境变量
## 1、燃动夏季—入会
export summer_movement_joinjoinjoinhui="false" ##是否入会 true 入会，false 不入会
## 2、燃动夏季—百元守卫战SH
export summer_movement_ShHelpFlag="1" ##0 不开启也不助力 1 开启并助力 2 开启但不助力 默认开启并助力
## 3、燃动夏季-新增只做邀请助力功能
export summer_movement_HelpHelpHelpFlag="true" ##是否只执行邀请助力 true 是 false 不是 默认 false
### 可以设置13点执行一下脚本
if [ $(date "+%H") -eq 13 ]; then
    export summer_movement_HelpHelpHelpFlag="true"
fi
## 4、京东签到图形验证修改火爆问题
### 如果 read ECONNRESET 错误 可以试试
### 环境变量 JOY_HOST 修改域名 https://jdjoy.jd.com 可以改成ip https://49.7.27.236
### 如果上面ip不行就自己去ping下域名对应的ip cmd窗口输入—>ping jdjoy.jd.com 再改
### 不要频繁请求 请过个半小时 1小时在执行
export JOY_HOST=""
## 5、图形验证文件 JDJRValidator_Pure.js 验证次数
### 新增验证次数上限 默认25次 验证可能无法成功
export JDJR_validator_Count="25"
## 6、财富大陆热气球接客次数
### 新增热气球接客 默认每次运行执行10次
export gua_wealth_island_serviceNum="10"
## 7、燃动夏季-新增屏蔽账号
### export summer_movement_outuserID="2,5,7" ##屏蔽第几个账号的例子
export summer_movement_outuserID=""
## 8、修复点点券
### 新增显示有多少个非法请求 可以开通知 
export DDQ_NOTIFY_CONTROL="" ##不填或false为通知，true为不通知

# cdle 环境变量
## 1、全民运动会守卫红包
### 助力码，需手动抓包
export olympicgames_inviteId=""
## 2、签到领现金兑换
### 填写 pt_pin@金额，pt_pin为用户名，可以在 COOKIES 中提取；金额为 2 或 10，例如 LiLei@2 或 HanMeimei@10。多值用 & 连接，例如 LiLei@2&HanMeimei@10
### export exchangeAccounts="$(echo $JD_COOKIE | sed "s/&/\n/g; s/\S*pt_pin=\([^;]\+\);\S*/\1@10/g; s/\n/\&/g;")"  ##兑10元现金，比较难兑
export exchangeAccounts="$(echo $JD_COOKIE | sed "s/&/ /g; s/\S*pt_pin=\([^;]\+\);\S*/\1@2/g; s/ /&/g;")"           ##兑2元现金
## 3、愤怒的现金
### 极速助力，打击黑产盗取现金的犯罪行为。默认向前助力9个账号，若要指定被助力账号，需cashHelpPins环境变量中填入需要助力的pt_pin，有多个请用@符号连接。
export cashHelpPins="$(echo $JD_COOKIE | sed "s/&/\n/g; s/\S*pt_pin=\([^;]\+\);\S*/\1/g; s/\n/@/g;")"
## 4、愤怒的锦鲤
### 助力账号，填写pt_pin或用户名的值。多个 pt_pin 值用 @ 连接
export kois="$(echo $JD_COOKIE | sed "s/&/\n/g; s/\S*pt_pin=\([^;]\+\);\S*/\1/g; s/\n/@/g;")"
## 5、发财大赢家助力
### 需要设置环境变量dyjHelpPins来指定要助力的账号
export dyjHelpPins="$(echo $JD_COOKIE | sed "s/&/\n/g; s/\S*pt_pin=\([^;]\+\);\S*/\1/g; s/\n/@/g;")"
## 6、早起赢现金
### 入口：京东汽车-瓜分万元
### 备注：支付一元才能参与活动，填写环境变量morningScPins给指定账号打卡
export morningScPins="$(echo $JD_COOKIE | sed "s/&/\n/g; s/\S*pt_pin=\([^;]\+\);\S*/\1/g; s/\n/@/g;")"
## 7、赚30元
### 备注：赚30元每日签到红包、天降红包助力，在earn30Pins环境变量中填入需要签到和接受助力的账号。
### 技巧：每月可以提现100元，但需要邀请一个新人下首单。可以用已注册手机号重新注册为新人账号，切换ip可以提高成功率。
export earn30Pins="$(echo $JD_COOKIE | sed "s/&/\n/g; s/\S*pt_pin=\([^;]\+\);\S*/\1/g; s/\n/@/g;")"
## 8、真·抢京豆
### 高速并发抢京豆，专治偷助力。设置环境变量angryBeanPins为指定账号助力，默认不助力。
### 环境变量angryBeanMode可选值priority或speed或smart，默认smart模式。
### 默认推送通知，如要屏蔽通知需将环境变量enableAngryBeanNotify的值设为false。
export angryBeanPins="$(echo $JD_COOKIE | sed "s/&/ /g; s/\S*pt_pin=\([^;]\+\);\S*/\1/g; s/ /@/g;")"
export angryBeanMode="smart"
export enableAngryBeanNotify="true"

# star261 环境变量
## 1、京喜工厂开团
### 默认第一个CK开团，例：若OPEN_DREAMFACTORY_TUAN="2,3"，则第2，第3个CK开团，其他账号参加第2，第3个CK开的团。每执行一次，会领取上一次成团的奖励和新开一次团，每天执行4次能开完3次团和领取3次团的奖励。一个账号能参团一次，一个账号一天能开三次团，请根据自己的情况设置需要开团的CK，一般至少5个CK能成团
### 助力规则：开团账号开团，其他账号自动参团。 例：有A,B,C账号，A，B账号开团，则B，C会参加A的团，A会参加B的团。账号内互助之后，开团账号若有剩下参团次数，会尝试加入作者团
### 成团条件：成团所需人数根据活动所需人数变化，一般为5-7人，若5人成团，则5个CK能成团一次，9个CK能成团两次，13个CK能成团三次
export OPEN_DREAMFACTORY_TUAN=""
## 2、燃动夏季
### 会助力作者百元守卫战 参数helpAuthorFlag 默认助力
### 百元守卫战,先脚本内互助，多的助力会助力作者
export helpAuthorFlag="true" ##是否助力作者SH true 助力，false 不助力
## 3、燃动夏季下注
### 每个奖品会花费200币下注，不想下注的人不要跑
### 若想下满注则设置环境变量 MAX_BET=true 前提：需要账号已经开通店铺会员
### 每日20点开奖，脚本会自动开奖
export MAX_BET="true"

# JDHelloWorld 环境变量
## 1、宠汪汪二代目
### 默认80，10、20、40、80可选
export feedNum="80"
### 默认双人跑
export JD_JOY_teamLevel="2"
## 2、新版京喜财富岛提现
### 提现金额，可选0.1 0.5 1 2 10
export CFD_CASHOUT_MONEY=10
### token，顺序、数量必须与cookie一致。抓包地址：https://m.jingxi.com/jxbfd/user/ExchangePrize
### export CFD_CASH_TOKEN='[{"strPgtimestamp":"你的值","strPhoneID":"你的值","strPgUUNum":"你的值"},{"strPgtimestamp":"你的值","strPhoneID":"你的值","strPgUUNum":"你的值"}]'
export CFD_CASH_TOKEN='[{"strPgtimestamp":"1626623544085","strPhoneID":"878e21db65d2d606","strPgUUNum":"56eaaf98f7d7a69c59e50c6bb40e79c1"}]'
## 3、宠汪汪等提示预存验证码数量不足
export validate_num="" ##你需要的数值

# Aaron-lv 环境变量
## 1、京东健康社区京豆兑换
export JD_HEALTH_REWARD_NAME="20" ##只能兑换京豆，填写纯数字20 10 5 3

# Ninja 环境变量
## 1、通知黑名单
### 使用 & 分隔，例如 东东乐园&东东萌宠
export NOTIFY_SKIP_LIST=""

# 不知名大佬环境变量
## 1、清空购物车
### 将需要跳过清理的账号(cookie中的pt_pin)放到变量CleanUsers中，多个用@隔开
export CleanUsers=""

# Tsukasa007 环境变量
## 1、定格夺冠
### 第一个账号助力Tsukasa007，其他依次助力CK1第一个CK失效应该全都会助力Tsukasa007，亲注意一下（其他脚本逻辑都差不多）
### 一天只能领400豆1个ck20豆，不设置变量默认只会运行到ck21，填写11就是跑到11个ck就停止，填写21就是跑到21个ck就停止，如果没豆那就改变量，ck多每天改一次收益最大化
export JD_OPENCARE_CHAMPIONSHIP=""
## 2、夏日呵护 母音甄选
### 一天只能领100豆1个ck10豆，不设置变量默认只会运行到ck11，填写11就是跑到11个ck就停止，填写22就是跑到22个ck就停止，一天最多助力10个ck，推荐11的倍数填写！！如果11没豆那就22如此类推，每天改一次收益最大化
export JD_SUMMER_MOM_OPENCARD=""
## 3、奥运夺金挑战赛
### 一天只能领200豆1个ck20豆，不设置变量默认只会运行到ck11，填写11就是跑到11个ck就停止，填写22就是跑到22个ck就停止，一天最多助力10个ck，推荐11的倍数填写！！每天改一次收益最大化
export JD_OLYMPIC_WIN_GOLD=""
## 4、全民奔跑 激扬奥运
### env OLYMPIC_START_DRAW = true 就是开启ck1抽奖 (!!!抽奖时间可能很长，慢慢抽吧!!!)
export OLYMPIC_START_DRAW="true"
export guaolympicopencard2="true"
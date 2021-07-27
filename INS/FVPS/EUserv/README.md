
### 给EUserv IPV6添加WARP，白嫖WARP高速通道！针对OpenVZ、LXC架构的IPV6 only VPS！

### IPV6 only VPS添加WARP的好处：

1：使只有IPV6的VPS获取访问IPV4的能力，套上WARP的ip,变成双栈VPS！

2：基本能隐藏VPS的真实IP！

3：支持代理协议直连电报Telegram，支持代理协议连通软路由Openwrt各种翻墙插件！

4：WARP分配的IPV4或者IPV6的IP段，都支持奈非Netflix流媒体，无视VPS原IP限制！

5：支持原本需要IPV4支持的Docker等应用！

6：加速VPS到CloudFlare CDN节点访问速度！

7：避开原VPS的IP需要谷歌验证码问题！

8：替代NAT64/DNS64方案，网络效率更高！

#### WARP原理与及搭建探讨：https://youtu.be/78dZgYFS-Qo

#### 抛弃DNS64、自定义域名、IP分流教程（推荐）：https://youtu.be/fY9HDLJ7mnM

#### 联合Oracle甲骨文https://github.com/YG-tsj/CFWarp-Pro #双栈Warp接管IPV4与IPV6网络：https://youtu.be/o7e_ikV-m-g
-------------------------------------------------------------------------------------------------------

### 一：恢复EUserv官方DNS64（重装系统者，可直接跳到第二步脚本安装）
```
echo -e "search blue.kundencontroller.de\noptions rotate\nnameserver 2a02:180:6:5::1c\nnameserver 2a02:180:6:5::4\nnameserver 2a02:180:6:5::1e\nnameserver 2a02:180:6:5::1d" > /etc/resolv.conf
```

### 二、重装系统能解决99%的问题！无须添加DNS64！一键到底！

#### 仅支持Debian 10/Ubuntu 20.04系统，根据自己需求选择以下脚本1或者脚本2（有无成功可查看脚本末尾提示）

#### 脚本1：IPV4是WARP分配的IP，IPV6是VPS本地IP
```
wget -qO- https://cdn.jsdelivr.net/gh/YG-tsj/EUserv-warp/warp4.sh|bash
```
#### 脚本2：IPV4与IPV6都是WARP分配的IP
```
wget -qO- https://cdn.jsdelivr.net/gh/YG-tsj/EUserv-warp/warp64.sh|bash
```
----------------------------------------------------------------------------------------------------
#### Netflix检测项目：https://github.com/YG-tsj/Netflix-Check

#### 注意：域名解析所填写的IP必须是VPS本地IP，与WARP分配的IP没关系！

#### 推荐使用Xray脚本项目（mack-a）：https://github.com/mack-a/v2ray-agent  注意：大家自行测试，德鸡在有些地区或者运营商不支持TCP，只能选择CDN（WS协议与gRPC协议），IP地址改为自定义优选IP，例：icook.tw

#### 提示：配置文件wgcf.conf和注册文件wgcf-account.toml都已备份在/etc/wireguard目录下！
--------------------------------------------------------------------------------------------------------------

#### 查看WARP当前统计状态：```wg```

#### 查看当前IPV4 IP：```curl -4 ip.p3terx.com```

#### 查看当前IPV6 IP：```curl -6 ip.p3terx.com```

------------------------------------------------------------------------------------------------------------- 
#### IPV6 VPS专用分流配置文件(以下默认全局IPV4优先，IP、域名自定义，详情见视频教程)
```
{ 
"outbounds": [
    {
      "tag":"IP6-out",
      "protocol": "freedom",
      "settings": {}
    },
    {
      "tag":"IP4-out",
      "protocol": "freedom",
      "settings": {
        "domainStrategy": "UseIPv4" 
      }
    }
  ],
  "routing": {
    "rules": [
      {
        "type": "field",
        "outboundTag": "IP4-out",
        "domain": [""] 
      },
      {
        "type": "field",
        "outboundTag": "IP6-out",
        "network": "udp,tcp" 
      }
    ]
  }
}
``` 
 ---------------------------------------------------------------------------------------------------------

#### 相关WARP进程命令

手动临时关闭WARP网络接口
```
wg-quick down wgcf
```
手动开启WARP网络接口 
```
wg-quick up wgcf
```

启动systemctl enable wg-quick@wgcf

开始systemctl start wg-quick@wgcf

重启systemctl restart wg-quick@wgcf

停止systemctl stop wg-quick@wgcf

关闭systemctl disable wg-quick@wgcf

---------------------------------------------------------------------------------------------------------------------

感谢P3terx大及原创者们，参考来源：
 
https://p3terx.com/archives/debian-linux-vps-server-wireguard-installation-tutorial.html

https://p3terx.com/archives/use-cloudflare-warp-to-add-extra-ipv4-or-ipv6-network-support-to-vps-servers-for-free.html

https://luotianyi.vc/5252.html

https://hiram.wang/cloudflare-wrap-vps/

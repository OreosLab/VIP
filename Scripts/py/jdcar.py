# -*- coding: utf-8 -*-
'''
pip3 install telethon pysocks httpx / py -3 -m pip install telethon pysocks httpx
'''
import os, time, json
from telethon import TelegramClient, events, sync

api_id_list = json.loads(os.environ['api_id_list']) #输入api_id，一个账号一项
api_hash_list = json.loads(os.environ['api_hash_list']) #输入api_hash，一个账号一项

# 东东工厂
jdfactory = os.environ.get('jdfactory')
# 京喜工厂
jxfactory = os.environ.get('jxfactory')
# 东东萌宠
jdpet = os.environ.get('jdpet')
# 种豆得豆
jdplantbean = os.environ.get('jdplantbean')
# 东东农场
jdfruit = os.environ.get('jdfruit')
# 签到领现金
jdcash = os.environ.get('jdcash')
# 闪购盲盒
jdsgmh = os.environ.get('jdsgmh')
# 东东健康
jdhealth = os.environ.get('jdhealth')


for num in range(len(api_id_list)):
	session_name = [ "id_" + str(i) for i in api_id_list ]
	client = TelegramClient(session_name[num], api_id_list[num], api_hash_list[num])
	client.start()
	#第一项是机器人ID，第二项是发送的文字
	# 种豆得豆
	if not jdplantbean is None:
		client.send_message("@JDHelpNewsBot", '/bean ' + jdplantbean)
	# 东东农场
	if not jdfruit is None:
		client.send_message("@JDHelpNewsBot", '/farm ' + jdfruit)
	# 京喜工厂
	if not jxfactory is None:
		client.send_message("@JDHelpNewsBot", '/jxfactory ' + jxfactory)
	# 闪购盲盒
	if not jdsgmh is None:
		client.send_message("@JDHelpNewsBot", '/sgmh ' + jdsgmh)
	# 东东工厂
	if not jdfactory is None:
		client.send_message("@JDHelpNewsBot", '/ddfactory ' + jdfactory)
	# 东东萌宠
	if not jdpet is None:
		client.send_message("@JDHelpNewsBot", '/pet ' + jdpet)
	# 东东健康
	if not jdhealth is None:
		client.send_message("@JDHelpNewsBot", '/health ' + jdhealth)
	
	time.sleep(5)	#延时5秒，等待机器人回应（一般是秒回应，但也有发生阻塞的可能）
	client.send_read_acknowledge("@JD_ShareCode_Bot")	#将机器人回应设为已读
	print("Done! Session name:", session_name[num])

os._exit(0)
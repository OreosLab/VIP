# !/usr/bin/env python3
import asyncio
import asyncio.subprocess
import difflib
import logging
import os
import re
import time

from telethon import TelegramClient, errors, events
from telethon.tl.types import MessageMediaWebPage, PeerChannel


# *********************************************************************************** #
api_id = 1234567  # your telegram api id
api_hash = "1234567890abcdefgh"  # your telegram api hash
bot_token = "1234567890:ABCDEFGHIJKLMNOPQRST"  # your bot_token
admin_id = 1234567890  # your chat id
save_path = "/usr/downloads"  # file save path
upload_file_set = False  # set upload file to google drive
drive_id = "5FyJClXmsqNw0-Rz19"  # google teamdrive id 如果使用OD，删除''内的内容即可。
drive_name = "gc"  # rclone drive name
max_num = 5  # 同时下载数量
# filter file name/文件名过滤
filter_list = ["你好，欢迎加入 Quantumu", "\n"]
# filter chat id /指定某些频道下载
whitelist = []
download_all_chat = False  # 监控所有你加入的频道，收到的新消息如果包含媒体都会下载，默认关闭
filter_file_name = ["sh"]  # 指定文件后缀，可以填jpg、avi、mkv、rar等。
proxy = ("socks5", "127.0.0.1", 4444)  # 自行替换代理设置，如果不需要代理，请删除括号内容
# pip3 install aiohttp cryptg hachoir pillow python-socks[asyncio] telethon
# *********************************************************************************** #

logging.basicConfig(
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s", level=logging.WARNING
)
logger = logging.getLogger(__name__)
queue = asyncio.Queue()


# 文件夹/文件名称处理
def validate_title(title):
    r_str = r"[\/\\\:\*\?\"\<\>\|\n]"  # '/ \ : * ? " < > |'
    return re.sub(r_str, "_", title)


# 获取相册标题
async def get_group_caption(message):
    group_caption = ""
    entity = await client.get_entity(message.to_id)
    async for msg in client.iter_messages(
        entity=entity, reverse=True, offset_id=message.id - 9, limit=10
    ):
        if msg.grouped_id == message.grouped_id and msg.text != "":
            group_caption = msg.text
            return group_caption
    return group_caption


# 获取本地时间
def get_local_time():
    return time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())


# 判断相似率
def get_equal_rate(str1, str2):
    return difflib.SequenceMatcher(None, str1, str2).quick_ratio()


# 返回文件大小
def bytes_to_string(byte_count):
    suffix_index = 0
    while byte_count >= 1024:
        byte_count /= 1024
        suffix_index += 1

    return "{:.2f}{}".format(
        byte_count, [" bytes", "KB", "MB", "GB", "TB"][suffix_index]
    )


async def worker(name):
    while True:
        queue_item = await queue.get()
        message = queue_item[0]
        chat_title = queue_item[1]
        entity = queue_item[2]
        file_name = queue_item[3]
        for filter_file in filter_file_name:
            if not file_name.endswith(filter_file):
                return
        dirname = validate_title(f"{chat_title}({entity.id})")
        datetime_dir_name = message.date.strftime("%Y年%m月")
        file_save_path = os.path.join(save_path, dirname, datetime_dir_name)
        if not os.path.exists(file_save_path):
            os.makedirs(file_save_path)
        # 判断文件是否在本地存在
        if file_name in os.listdir(file_save_path):
            os.remove(os.path.join(file_save_path, file_name))
        print(f"{get_local_time()} 开始下载： {chat_title} - {file_name}")
        try:
            loop = asyncio.get_event_loop()
            task = loop.create_task(
                client.download_media(message, os.path.join(file_save_path, file_name))
            )
            await asyncio.wait_for(task, timeout=3600)
            if upload_file_set:
                proc = await asyncio.create_subprocess_exec(
                    "fclone",
                    "move",
                    os.path.join(file_save_path, file_name),
                    f"{drive_name}:{{{drive_id}}}/{dirname}/{datetime_dir_name}",
                    "--ignore-existing",
                    stdout=asyncio.subprocess.DEVNULL,
                )
                await proc.wait()
                if proc.returncode == 0:
                    print(f"{get_local_time()} - {file_name} 下载并上传完成")
        except (errors.rpc_errors_re.FileReferenceExpiredError, asyncio.TimeoutError):
            logging.warning(f"{get_local_time()} - {file_name} 出现异常，重新尝试下载！")
            async for new_message in client.iter_messages(
                entity=entity, offset_id=message.id - 1, reverse=True, limit=1
            ):
                await queue.put((new_message, chat_title, entity, file_name))
        except Exception as e:
            print(f"{get_local_time()} - {file_name} {e.__class__} {e}")
            await bot.send_message(admin_id, f"{e.__class__}!\n\n{e}\n\n{file_name}")
        finally:
            queue.task_done()
            # 无论是否上传成功都删除文件。
            if upload_file_set:
                try:
                    os.remove(os.path.join(file_save_path, file_name))
                except Exception:
                    pass


@events.register(events.NewMessage(pattern="/start", from_users=admin_id))
async def handler(update):
    text = update.message.text.split(" ")
    if len(text) == 1 or len(text) not in [2, 3]:
        msg = (
            "参数错误，请按照参考格式输入:\n\n"
            "1.普通群组\n"
            "<i>/start https://t.me/fkdhlg 0 </i>\n\n"
            "2.私密群组(频道) 链接为随便复制一条群组消息链接\n"
            "<i>/start https://t.me/12000000/1 0 </i>\n\n"
            "Tips:如果不输入offset_id，默认从第一条开始下载"
        )
        await bot.send_message(admin_id, msg, parse_mode="HTML")
        return
    elif len(text) == 2:
        chat_id = text[1]
        offset_id = 0
        try:
            entity = await client.get_entity(chat_id)
            chat_title = entity.title
            await update.reply(f"开始从 {chat_title} 的第 {0} 条消息下载")
        except ValueError:
            channel_id = text[1].split("/")[4]
            entity = await client.get_entity(PeerChannel(int(channel_id)))
            chat_title = entity.title
            await update.reply(f"开始从 {chat_title} 的第 {0} 条消息下载")
        except Exception as e:
            await update.reply(
                "chat输入错误，请输入频道或群组的链接\n\n" f"错误类型：{e.__class__}" f"异常消息：{e}"
            )
            return
    else:
        chat_id = text[1]
        offset_id = int(text[2])
        try:
            entity = await client.get_entity(chat_id)
            chat_title = entity.title
            await update.reply(f"开始从 {chat_title} 的第 {offset_id} 条消息下载")
        except ValueError:
            channel_id = text[1].split("/")[4]
            entity = await client.get_entity(PeerChannel(int(channel_id)))
            chat_title = entity.title
            await update.reply(f"开始从 {chat_title} 的第 {offset_id} 条消息下载")
        except Exception as e:
            await update.reply(
                "chat输入错误，请输入频道或群组的链接\n\n" f"错误类型：{type(e).__class__}" f"异常消息：{e}"
            )
            return
    if chat_title:
        print(f"{get_local_time()} - 开始下载：{chat_title}({entity.id}) - {offset_id}")
        last_msg_id = 0
        async for message in client.iter_messages(
            entity, offset_id=offset_id, reverse=True, limit=None
        ):
            if message.media:
                # 如果是一组媒体
                caption = (
                    await get_group_caption(message)
                    if (message.grouped_id and message.text == "")
                    else message.text
                )
                # 过滤文件名称中的广告等词语
                if len(filter_list) and caption != "":
                    for filter_keyword in filter_list:
                        caption = caption.replace(filter_keyword, "")
                # 如果文件文件名不是空字符串，则进行过滤和截取，避免文件名过长导致的错误
                caption = "" if caption == "" else f"{validate_title(caption)} - "[:50]
                file_name = ""
                # 如果是文件
                if message.document:
                    if type(message.media) == MessageMediaWebPage:
                        continue
                    if message.media.document.mime_type == "image/webp":
                        continue
                    if message.media.document.mime_type == "application/x-tgsticker":
                        continue
                    for i in message.document.attributes:
                        try:
                            file_name = i.file_name
                        except Exception:
                            continue
                    if file_name == "":
                        file_name = f'{message.id} - {caption}.{message.document.mime_type.split("/")[-1]}'
                    else:
                        # 如果文件名中已经包含了标题，则过滤标题
                        if get_equal_rate(caption, file_name) > 0.6:
                            caption = ""
                        file_name = f"{message.id} - {caption}{file_name}"
                elif message.photo:
                    file_name = f"{message.id} - {caption}{message.photo.id}.jpg"
                else:
                    continue
                await queue.put((message, chat_title, entity, file_name))
                last_msg_id = message.id
        await bot.send_message(
            admin_id,
            f"{chat_title} all message added to task queue, last message is：{last_msg_id}",
        )


@events.register(events.NewMessage())
async def all_chat_download(update):
    message = update.message
    if message.media:
        chat_id = update.message.to_id
        entity = await client.get_entity(chat_id)
        if entity.id not in whitelist:
            return
        chat_title = entity.title
        # 如果是一组媒体
        caption = (
            await get_group_caption(message)
            if (message.grouped_id and message.text == "")
            else message.text
        )
        if caption != "":
            for fw in filter_list:
                caption = caption.replace(fw, "")
        # 如果文件文件名不是空字符串，则进行过滤和截取，避免文件名过长导致的错误
        caption = "" if caption == "" else f"{validate_title(caption)} - "[:50]
        file_name = ""
        # 如果是文件
        if message.document:
            try:
                if type(message.media) == MessageMediaWebPage:
                    return
                if (
                    message.media.document.mime_type
                    == "application/x-tgsticker"
                ):
                    file_name = f"{message.media.document.id}.tgs"
                elif message.media.document.mime_type == "image/webp":
                    file_name = f"{message.media.document.id}.webp"
                for i in message.document.attributes:
                    try:
                        file_name = i.file_name
                    except Exception:
                        continue
                if file_name == "":
                    file_name = f'{message.id} - {caption}.{message.document.mime_type.split("/")[-1]}'
                else:
                    # 如果文件名中已经包含了标题，则过滤标题
                    if get_equal_rate(caption, file_name) > 0.6:
                        caption = ""
                    file_name = f"{message.id} - {caption}{file_name}"
            except Exception:
                print(message.media)
        elif message.photo:
            file_name = f"{message.id} - {caption}{message.photo.id}.jpg"
        else:
            return
        # 过滤文件名称中的广告等词语
        for filter_keyword in filter_list:
            file_name = file_name.replace(filter_keyword, "")
        print(chat_title, file_name)
        await queue.put((message, chat_title, entity, file_name))


if __name__ == "__main__":
    bot = TelegramClient(
        "telegram_channel_downloader_bot", api_id, api_hash, proxy=proxy
    ).start(bot_token=str(bot_token))
    client = TelegramClient(
        "telegram_channel_downloader", api_id, api_hash, proxy=proxy
    ).start()
    bot.add_event_handler(handler)
    if download_all_chat:
        client.add_event_handler(all_chat_download)
    tasks = []
    try:
        for i in range(max_num):
            loop = asyncio.get_event_loop()
            task = loop.create_task(worker(f"worker-{i}"))
            tasks.append(task)
        print("Successfully started (Press Ctrl+C to stop)")
        client.run_until_disconnected()
    finally:
        for task in tasks:
            task.cancel()
        client.disconnect()
        print("Stopped!")

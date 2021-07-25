#!/bin/bash

dir_sync=/root/Help/互助研究院\(1597522865\)/2021年07月


(
  echo "resolve_username DlHelper_bot"
  sleep 5

  echo "msg DlHelper /start https://t.me/update_help" 
  echo "safe_quit"
) | docker exec -i telegram-cli telegram-cli -N

find $dir_sync -name "*code\.sh" -exec mv {} $dir_sync/code\.sh \;
find $dir_sync -name "*task_before\.sh" -exec mv {} $dir_sync/task_before\.sh \;
find $dir_sync -name "*config_sample\.sh" -exec mv {} $dir_sync/config_sample\.sh \;

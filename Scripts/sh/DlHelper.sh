#!/bin/bash



(
  echo "resolve_username DlHelper_bot"
  sleep 5

  echo "msg DlHelper /start https://t.me/update_help" 
  echo "safe_quit"
) | docker exec -i telegram-cli telegram-cli -N
#!/bin/bash



(
  #echo "resolve_username TuringLabbot"
  #echo "resolve_username LvanLamCommitCodebot"
  echo "resolve_username GitHubBot" #换成你要测试的用户或者bot，诸如@GitHubBot@后面的 GitHubBot 
  sleep 5
  ### @Turing_Lab_Bot
  ###京喜财富岛
  #echo "msg Turing_Lab_Bot /submit_activity_codes jxcfd 互助码"
  ###京喜工厂
  #echo "msg Turing_Lab_Bot /submit_activity_codes jxfactory 互助码"
  ###种豆得豆
  #echo "msg Turing_Lab_Bot /submit_activity_codes bean 互助码"
  ###东东农场
  #echo "msg Turing_Lab_Bot /submit_activity_codes farm 互助码"
  ###东东萌宠
  #echo "msg Turing_Lab_Bot /submit_activity_codes pet 互助码"
  ###东东工厂
  #echo "msg Turing_Lab_Bot /submit_activity_codes ddfactory 互助码"
  ###闪购盲盒
  #echo "msg Turing_Lab_Bot /submit_activity_codes sgmh 互助码"
  ###健康社区
  #echo "msg Turing_Lab_Bot /submit_activity_codes health 互助码"
  ### @Commit_Code_Bot
  ###JD签到领现金
  #echo "msg Commit_Code_Bot /jdcash 互助码"
  ### JD赚赚
  #echo "msg Commit_Code_Bot /jdzz 互助码"
  ### JD疯狂的小狗
  #echo "msg Commit_Code_Bot /jdcrazyjoy 互助码"

  ###过期活动
  ###京东环球挑战赛
  #echo "msg Turing_Lab_Bot /submit_activity_codes jdglobal 互助码"
  ###测试 这里填对话框或列表显示的名字，如GitHub；空格用_代替，如Telegram_抽奖助手
  echo "msg GitHub 这是一条17:45的测试消息" 
  echo "safe_quit"
  ###要用的地方全部取消注释#，命令行输入crontab -e，设置完cron后重连一下ssh较为有效
) | docker exec -i telegram-cli telegram-cli -N

#!/bin/sh
echo "----------------------------Turing Lab Bot begin--------------------------------" > sharecode.txt
code_farm=''
code_jxfactory=''
code_ddfactory=''
code_pet=''
code_jxcfd=''
code_sgmh=''
code_bean=''
code_health=''
code_jdzz=''
code_jdcrazyjoy=''
code_city=''
code_carnivalcity=''
while read line
do
    if [[ $line == *"东东农场"* ]]; then
      code_farm="${code_farm}&${line#【*】 }"
    elif [[ $line == *"京喜工厂"* ]]; then
      code_jxfactory="${code_jxfactory}&${line#【*】 }"
    elif [[ $line == *"东东工厂"* ]]; then
      code_ddfactory="${code_ddfactory}&${line#【*】 }"
    elif [[ $line == *"东东萌宠"* ]]; then
      code_pet="${code_pet}&${line#【*】 }"
    elif [[ $line == *"财富岛"* ]]; then
      code_jxcfd="${code_jxcfd}&${line#【*】 }"
    elif [[ $line == *"闪购盲盒"* ]]; then
      code_sgmh="${code_sgmh}&${line#【*】 }"
    elif [[ $line == *"种豆得豆"* ]]; then
      code_bean="${code_bean}&${line#【*】 }"
    elif [[ $line == *"种豆得豆"* ]]; then
      code_bean="${code_bean}&${line#【*】 }"
    elif [[ $line == *"健康社区"* ]]; then
      code_health="${code_health}&${line#【*】 }"
    elif [[ $line == *"城城领现金好友互助码"* ]]; then
      code_city="${code_city}&${line#【*】 }"
    fi
done < logs/sharecodeCollection.log
echo "/submit_activity_codes farm ${code_farm#&}" >> sharecode.txt
echo "/submit_activity_codes jxfactory ${code_jxfactory#&}" >> sharecode.txt
echo "/submit_activity_codes ddfactory ${code_ddfactory#&}" >> sharecode.txt
echo "/submit_activity_codes pet ${code_pet#&}" >> sharecode.txt
echo "/submit_activity_codes jxcfd ${code_jxcfd#&}" >> sharecode.txt
echo "/submit_activity_codes sgmh ${code_sgmh#&}" >> sharecode.txt
echo "/submit_activity_codes bean ${code_bean#&}" >> sharecode.txt
echo "/submit_activity_codes health ${code_health#&}" >> sharecode.txt
echo "/submit_activity_codes city ${code_city#&}" >> sharecode.txt
while read line
do
    if [[ $line == *"手机狂欢城好友互助码"* ]]; then
      code_carnivalcity="${code_carnivalcity}&${line#*】}"
    fi
done < logs/jd_carnivalcity.log
echo "/submit_activity_codes carnivalcity ${code_carnivalcity#&}" >> sharecode.txt
echo "----------------------------Turing Lab Bot end--------------------------------" >> sharecode.txt
echo -e "\n\n\n----------------------------Commit Code Bot begin--------------------------------" >> sharecode.txt
while read line
do
    if [[ $line == *"京东赚赚"* ]]; then
      code_jdzz="${code_jdzz}&${line#【*】 }"
    elif [[ $line == *"crazyJoy"* ]]; then
      code_jdcrazyjoy="${code_jdcrazyjoy}&${line#【*】 }"
    fi
done < logs/sharecodeCollection.log
echo "/jdzz ${code_jdzz#&}" >> sharecode.txt
echo "/jdcrazyjoy ${code_jxfactory#&}" >> sharecode.txt
echo "----------------------------Commit Code Bot end--------------------------------" >> sharecode.txt
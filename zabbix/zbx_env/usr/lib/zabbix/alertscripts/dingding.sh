#!/bin/bash
# Auther: https://notes.jangrui.com
# update time: 2019-12.19
# description: 钉钉部门自定义机器人报警脚本

Sendto=$1
Subject=$2
Message=$3
SendUrl=$4

curl "$SendUrl" -H 'Content-Type: application/json' -d '{
    "msgtype": "text",
    "text": {
        "content": "'"$Subject\n$Message"'"
    },
    "at":{
        "atMobiles": [ "'"$Sendto"'" ],
        "isAtAll": false
    }
}'

time=`date +"%Y-%m-%d"`
echo -e "`date` \n接收用户: $Sendto \n$Subject \n$Message \n" >> /var/log/zabbix/zbx_dingding-$time.log

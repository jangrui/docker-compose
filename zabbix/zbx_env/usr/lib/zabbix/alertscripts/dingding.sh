#!/bin/bash
# Auther: https://notes.jangrui.com
# update time: 2019-12.19
# description: 钉钉部门自定义机器人报警脚本

dingding() {
    curl "$SendUrl" -H 'Content-Type: application/json' -d '{
        "msgtype": "text",
        "text": {
            "content": "'"$Subject \n$Message"'"
        },
        "at":{
        "atMobiles": [ "'"$Sendto"'" ],
        "isAtAll": false
        }
    }'

    time=`date +"%Y-%m-%d"`
    echo -e "`date` \n接收用户: $Sendto \n$Subject \n$Message \n" >> /var/log/zabbix/zbx_dingding-$time.log
}

# zabbix 告警媒介脚本参数 1
Sendto=$1
# zabbix 告警媒介脚本参数 2
Subject=$2
# zabbix 告警媒介脚本参数 3
Message=$3
# zabbix 告警媒介脚本参数 4 && 钉钉部门自定义机器人 webhook
SendUrl=$4

if [[ $# != 4 ]]; then
    echo "Usage: $0 Sendto Subject Message SendUrl"
    return 1
fi

dingding

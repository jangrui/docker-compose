#!/bin/bash
# Auther: https://notes.jangrui.com/#/zabbix/wechat
# update time: 2019-12.19
# description: 企业微信自定义应用报警脚本

wechat(){
    curl "$SendUrl" -H 'Content-Type: application/json' -d '{
        "touser": "'"$Sendto"'",
        "toparty": "'"$PartyId"'",
        "msgtype": "text",
        "agentid": "'"$AgentId"'",
        "text": {
            "content": "'"$Subject\n$Message"'"
        },
        "safe": 0
    }'

    time=`date +"%Y-%m-%d"`
    echo -e "`date` \n接收用户: $Sendto \n$Subject \n$Message \n" >> /var/log/zabbix/zbx_dingding-$time.log
}

# 企业微信部门 id && zabbix 参数 7
Sendto=$1
# zabbix 参数 2
Subject=$2
# zabbix 参数 3
Message=$3
# 企业微信 CropID && zabbix 参数 4
CropID=$4
# 企业微信应用 id && zabbix 参数 6
AgentId=$5
# 企业微信 CropID && zabbix 参数 5
Secret=$6
# 企业微信部门 id && zabbix 参数 7
PartyId=$7

TokenUrl="https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=$CropID&corpsecret=$Secret" 
Token=$(/usr/bin/curl -s -G $TokenUrl | awk -F \" '{print $10}')
SendUrl="https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=$Token"

if [[ $# != 4 ]]; then
    echo "Usage: $0 Sendto Subject Message CropID Secret AgentId PartyId"
    return 1
fi

wechat

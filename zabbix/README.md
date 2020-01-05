# Docker 部署分布式 Zabbix 监控系统

## 模拟环境

|zabbix-server    <=|zabbix-proxy           <=|zabbix-agent          |
|-|-|-|
|zabbix.jangrui.com |zabbix.jangrui.com:10061 |beijing_1.jangrui.com |
|                   |                         |beijing_2.jangrui.com |
|                   |shproxy.jangrui.com      |shanghai_1.jangrui.com|
|                   |                         |shanghai_2.jangrui.com|
|                   |qdproxy.jangrui.com      |qingdao_1.jangrui.com |
|                   |                         |qingdao_2.jangrui.com |

## 部署 zabbix-server

设置域名解析，指定监控服务器主机名并重新登录

```
hostnamectl set-hostname zabbix.jangrui.com
```

docker-compose.yml 包含 mysql、zabbix-java-gateway、zabbix-snmptraps、zabbix-server、zabbix-web、zabbix-proxy、zabbix-agent

```
git clone https://github.com/jangrui/docker-compose
cd docker-compose/zabbix
docker-compose up -d
```

## 部署 zabbix-proxy

设置域名解析，指定代理服务器主机名并重新登录

```
hostnamectl set-hostname shproxy.jangrui.com
```

proxy.yml 包含 mysql、zabbix-java-gateway、zabbix-snmptraps、zabbix-proxy、zabbix-agent

```
git clone https://github.com/jangrui/docker-compose
cd docker-compose/zabbix
# sed -i 's,zabbix.jangrui.com,youdomain.com,g' proxy.yml
docker-compose -f proxy.yml up -d
```

## 部署 zabbix-agent

设置域名解析，指定被监控服务器主机名并重新登录

```
hostnamectl set-hostname shanghai_1.jangrui.com
```

agent.yml 包含 zabbix-agent

```
git clone https://github.com/jangrui/docker-compose
cd docker-compose/zabbix
# sed -i 's,shproxy.jangrui.com,youdomain.com,g' agent.yml
docker-compose -f  agent.yml up -d
```

## Web 设置

> 更改中文后图形乱码已修复。

### 创建代理

管理 => agent 代理程序 => 创建代理 => 代理名称：代理服务器主机名 => 代理地址：代理服务器主机名

### 创建主机组

配置 => 主机群组 => 创建主机群组

### 创建自动注册

配合 => 动作 => 事件源：自动注册 => 定义名称 => 触发条件：主机元数据 => 包含：youdomain.com => 添加 => 触发条件：agent 代理程序 => 选择代理 => 添加 => 添加 => 操作 => 操作细节 => 新的：添加到主机组、添加主机、关联模板 => 添加

> 如果发现主机后，监测无法获取最新数据，重启 zabbix-proxy 即可
> 
> zabbix-server 服务器： `docker-compose restart proxy`
>
> zabbix-proxy 服务器： `docker-compose -f proxy.yml restart proxy`

### 创建报警媒介

- 微信告警

管理 => 报警媒介类型 => 创建媒介类型 => 名称：微信报警 => 类型：脚本 => 脚本名称：wechat.sh => 脚本参数 => 添加

> 脚本参数：
> - {{ALERT.SENDTO}}
> - {{ALERT.SUBJECT}}
> - {{ALERT.MESSAGE}}
> - 企业微信 CropID
> - 企业微信 Secret
> - 企业微信 AgentID
> - 企业微信部门 ID

- 钉钉告警

管理 => 报警媒介类型 => 创建媒介类型 => 名称：微信报警 => 类型：脚本 => 脚本名称：wechat.sh => 脚本参数 => 添加

> 脚本参数：
> - {{ALERT.SENDTO}}
> - {{ALERT.SUBJECT}}
> - {{ALERT.MESSAGE}}
> - 钉钉部门自定义机器人 webhook

报警脚本目录：
zbx_env/usr/lib/zabbix/alertscripts/wechat.sh
zbx_env/usr/lib/zabbix/alertscripts/dingding.sh

### 创建自动报警

配置 => 动作 => 事件源：触发器 => 创建动作 => 名称 => 操作 => 持续时间：1m => 标题：故障告警 => 内容 => 操作：新的 => 步骤：1-0 => 操作类型：发送消息 => 发送到群组：添加群组 => 仅送到：微信告警 => 添加 => 恢复操作 => 标题：告警恢复 => 消息内容 => 操作：新的 => 操作类型：通知所有参与者 => 添加

操作消息内容：

```
⚠️ {EVENT.NAME}
告警时间：
    {EVENT.TIME} on {EVENT.DATE}
告警主机: 
    {HOST.NAME}
告警等级: 
    {EVENT.SEVERITY}
告警事件: 
    {EVENT.ID}
```

恢复操作内容：

```
✅{EVENT.NAME}
恢复时间：
    {EVENT.RECOVERY.TIME} on {EVENT.RECOVERY.DATE}
告警主机: 
    {HOST.NAME}
告警等级: 
    {EVENT.SEVERITY}
告警事件: 
    {EVENT.ID}
```

管理 => 用户 => 报警媒介 => 添加 => 微信告警 => 收件人：企业微信用户id => 添加

## Grafana 配置

默认安装了 zabbix 插件

> zabbix api: http://zabbix.example.com/api_jsonrpc.php

- 创建 zabbix 监控图表

1. Configuration => plugins => zabbix => enable
2. Configuration => Data Sources => Add data source => zabbix => url => http://zabbix-web/api_jsonrpc.php => username: Admin => passwd: zabbix => zabbix version: 4.x => save
3. Create => Add Query => Group: Discovered hosts => Host: /.*/ => Application: CPU => Item: /Load/ => Save dashboard

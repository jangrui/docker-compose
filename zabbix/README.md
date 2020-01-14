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

![zabbix proxy](https://notes.jangrui.com/_media/zabbix/proxy.gif)

### 创建主机组

配置 => 主机群组 => 创建主机群组

### 创建自动注册

![自动注册主机](https://notes.jangrui.com/_media/zabbix/auto_registration_host.gif)

- 触发条件

1. 主机名：zabbix_agent 主机名包含字段；
2. 主机元数据：zabbix_agent.conf 配置 HostMetadataItem ，zabbix-server/proxy 获取对应 key 值所包含字段；

> 如果发现主机后，监测无法获取最新数据，重启 zabbix-proxy 即可
> 
> zabbix-server 服务器： `docker-compose restart proxy`
>
> zabbix-proxy 服务器： `docker-compose -f proxy.yml restart proxy`

### 创建报警媒介

- 微信告警

![zabbix 添加微信报警媒介](https://notes.jangrui.com/_media/zabbix/media-types-wechat.gif)

> 脚本参数：
> - {ALERT.SENDTO}
> - {ALERT.SUBJECT}
> - {ALERT.MESSAGE}
> - 企业微信 ID
> - 企业微信自建应用 AgentId
> - 企业微信自建应用 Secret
> - 企业微信部门 ID

> [zabbix 添加微信报警媒介](https://notes.jangrui.com/#/zabbix/wechat)

- 钉钉告警

![zabbix 添加钉钉报警媒介](https://notes.jangrui.com/_media/zabbix/media-types-dingding.gif)

> 脚本参数：
> - {ALERT.SENDTO}
> - {ALERT.SUBJECT}
> - {ALERT.MESSAGE}
> - 钉钉部门群自定义机器人 webhook

报警脚本目录：
zbx_env/usr/lib/zabbix/alertscripts/wechat.sh
zbx_env/usr/lib/zabbix/alertscripts/dingding.sh

> [zabbix 添加钉钉报警媒介](https://notes.jangrui.com/#/zabbix/dingding)

### 用户添加报警媒介

![zabbix 用户添加报警媒介](https://notes.jangrui.com/_media/zabbix/media-types-wechat-user.gif)

### 创建自动报警

![zabbix 添加自动报警](https://notes.jangrui.com/_media/zabbix/media-types-wechat-action.gif)

>操作默认标题：`故障报警：`
>
> 操作消息内容：
> ```
> ⚠️ {EVENT.NAME}
> 告警时间：
>     {EVENT.TIME} on {EVENT.DATE}
> 告警主机: 
>     {HOST.NAME}
> 告警等级: 
>     {EVENT.SEVERITY}
> 告警事件: 
>     {EVENT.ID}
> ```
>
>恢复操作默认标题：`故障恢复：`
>
> 恢复操作消息内容：
> ```
> ✅{EVENT.NAME}
> 恢复时间：
>     {EVENT.RECOVERY.TIME} on > {EVENT.RECOVERY.DATE}
> 告警主机: 
>     {HOST.NAME}
> 告警等级: 
>     {EVENT.SEVERITY}
> 告警事件: 
>     {EVENT.ID}
> ```

## Grafana 配置

默认安装了 zabbix 插件

> zabbix api: http://zabbix.example.com/api_jsonrpc.php
> 
> Grafana 默认账号：admin，密码：admin

- 创建 zabbix 监控图表

![Grafana 创建 zabbix 监控图表](https://notes.jangrui.com/_media/zabbix/grafana.gif)

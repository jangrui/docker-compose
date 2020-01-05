FROM zabbix/zabbix-server-mysql:alpine-latest

USER root

RUN apk update && \
apk add --no-cache curl tzdata && \
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

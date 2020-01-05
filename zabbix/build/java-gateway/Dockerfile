FROM zabbix/zabbix-java-gateway:alpine-latest

USER root

RUN apk update && \
apk add --no-cache tzdata && \
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

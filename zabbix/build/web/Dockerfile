FROM zabbix/zabbix-web-nginx-mysql:alpine-latest

COPY ./fonts/jh.ttf assets/fonts/

RUN apk update && \
apk add --no-cache tzdata && \
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
sed -i 's,DejaVuSans,jh,' include/defines.inc.php

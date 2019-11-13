FROM  mysql:5.7

LABEL maintainer Jangrui <admin@jangrui.com>

COPY ./config/sql-init.sh /docker-entrypoint-initdb.d/
COPY ./config/update-config.sh /usr/local/bin/update-config.sh
COPY ./config/entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY ./config/my-master.cnf /etc/
COPY ./config/my-slave1.cnf /etc/
COPY ./config/my-slave2.cnf /etc/

RUN chmod +x /usr/local/bin/docker-entrypoint.sh && \
    chmod +x /docker-entrypoint-initdb.d/sql-init.sh && \
    chmod +x /usr/local/bin/update-config.sh

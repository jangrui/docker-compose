FROM centos:latest

LABEL maintainer="jangrui"

RUN yum update -y && yum install -y epel-release \
    && yum install -y redis \
    && yum clean all \
    && sed -i 's|^bind.*|bind 0.0.0.0|' /etc/redis.conf \
    && sed -i 's|^protected-mode.*|protected-mode no|' /etc/redis.conf

EXPOSE 6379
CMD [ "redis-server" ]

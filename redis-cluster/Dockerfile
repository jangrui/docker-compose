FROM redis:latest

MAINTAINER Jangrui <admin@jangrui.com>

# Redis Config
ADD config/redis.conf /data/redis.conf
RUN chown redis:redis /data/redis.conf

# Sentinel Config
EXPOSE 26379
ADD config/sentinel.conf /data/sentinel.conf
RUN chown redis:redis /data/sentinel.conf

ENV SENTINEL_QUORUM 2
ENV SENTINEL_DOWN_AFTER 30000
ENV SENTINEL_FAILOVER 180000

COPY config/sentinel-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/sentinel-entrypoint.sh
ENTRYPOINT ["sentinel-entrypoint.sh"]

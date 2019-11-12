FROM golang:1.13.4

RUN sed -i 's,deb.debian.org,mirrors.aliyun.com,g' /etc/apt/sources.list \
    && sed -i 's,security.debian.org,mirrors.aliyun.com,g' /etc/apt/sources.list

RUN apt-get update \
    && apt-get install -y autoconf \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV GOPATH /gopath
ENV CODISLABS ${GOPATH}/src/github.com/CodisLabs
ENV CODIS ${CODISLABS}/codis
ENV PATH ${GOPATH}/bin:${PATH}:${CODIS}/bin

WORKDIR ${CODISLABS}
RUN git clone https://github.com/CodisLabs/codis.git

WORKDIR ${CODIS}
RUN git checkout release3.2-redis-4.0.1

WORKDIR ${CODIS}
RUN make

WORKDIR /codis

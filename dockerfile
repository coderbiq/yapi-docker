FROM node:11-alpine as builder
LABEL maintainer="biqiang <biqiang001@gmail.com>" vendors="1.0"

ENV YAPI_VERSION="1.9.1"

RUN echo -e "https://mirrors.aliyun.com/alpine/v3.6/main/\nhttps://mirrors.aliyun.com/alpine/v3.6/community/" > /etc/apk/repositories \
    && apk add --no-cache git python make openssl tar gcc

RUN wget -O yapi.tgz https://registry.npm.taobao.org/yapi-vendor/download/yapi-vendor-${YAPI_VERSION}.tgz

RUN mkdir /apiVendors \
    && tar -xf yapi.tgz -C /apiVendors --strip-components=1 \
    && cd /apiVendors \
        && npm install --production --registry https://registry.npm.taobao.org


FROM node:11-alpine

ENV TZ="Asia/Shanghai" HOME="/"

WORKDIR ${HOME}
COPY --from=builder /apiVendors /api/vendors
COPY config.json /api/
EXPOSE 3000

FROM ubuntu:20.04

ENV TZ=Asia/Tokyo

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

RUN apt-get update

RUN apt-get install -y \
        wget \
        git \
        make \
        autoconf \
        automake \
        autotools-dev \
        libtool \
        pkg-config \
        libssl-dev

RUN cd /usr/local/src/ && \
    git clone https://github.com/tatsuhiro-t/nghttp2.git && \
    cd ./nghttp2/ && \
    autoreconf -i && automake && autoconf && ./configure && make && make install

ARG version="7.64.1"

RUN cd /usr/local/src/ && \
    wget https://curl.haxx.se/download/curl-${version}.tar.gz && \
    tar -zxvf ./curl-${version}.tar.gz && \
    cd ./curl-${version} && \
    ./configure --with-nghttp2=/usr/local --with-ssl && make && make install && ldconfig

ADD send_push.sh /var/tmp/

ADD keys /var/tmp/keys

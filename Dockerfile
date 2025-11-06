#
# Btcd Dockerfile
#
# https://github.com/
#

# Pull base image.
FROM debian:trixie

LABEL org.opencontainers.image.authors="hihouhou < hihouhou@hihouhou.com >"

ENV GOROOT=/usr/local/go
ENV GOPATH=/opt/btcd
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH
ENV GO_VERSION=1.25.3
ENV BTCD_VERSION=v0.25.0

# Update & install packages for go-callisto dep
RUN apt-get update && \
    apt-get install -y wget git make build-essential

# Get go
RUN wget https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz && \
    tar -xvf go${GO_VERSION}.linux-amd64.tar.gz && \
    mv go /usr/local

WORKDIR /opt/btcd
# Get btcd from github
RUN mkdir -p $GOPATH/src/github.com/btcsuite && \
    cd $GOPATH/src/github.com/btcsuite && \
    git clone https://github.com/btcsuite/btcd.git && \
    find / -name btcd -type d && \
    cd $GOPATH/src/github.com/btcsuite/btcd && \
    GO111MODULE=on go install -v . ./cmd/...

RUN useradd -ms /bin/bash btcd && \
    usermod -u 1000 btcd

USER btcd

CMD btcd $OPTIONS

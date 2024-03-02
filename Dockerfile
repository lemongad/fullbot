FROM golang:1.20.7-alpine AS builder

WORKDIR /app/FullTCore
RUN apk add --no-cache upx git
RUN git clone -b meta https://github.com/AirportR/FullTCore.git /app/FullTCore && \
    go build -tags with_gvisor -ldflags="-s -w" fulltclash.go && \
    mkdir /app/FullTCore-file && \
    cp /app/FullTCore/fulltclash /app/FullTCore-file/FullTCore && \
    chmod +x /app/FullTCore-file/FullTCore && \
    upx -9 /app/FullTCore-file/FullTCore
# Download, extract, chmod and clean gost
RUN wget -t 2 -T 10 https://github.com/go-gost/gost/releases/download/v3.0.0-rc8/gost_3.0.0-rc8_linux_amd64v3.tar.gz && \
    tar -xzvf gost_3.0.0-rc8_linux_amd64v3.tar.gz && \
    chmod +x gost && \
    upx -9 gost && \
    mv gost /bin/gost && \
    rm -f gost_3.0.0-rc8_linux_amd64v3.tar.gz

FROM python:alpine3.18

WORKDIR /app

ENV TZ=Asia/Shanghai
ENV CORE=1
ENV THREAD=4
ENV PROXY=0

COPY . /app

RUN apk add --no-cache \
    git gcc g++ make libffi-dev tzdata && \
    pip3 install --no-cache-dir -r requirements.txt && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    apk del gcc g++ make libffi-dev tzdata && \
    rm -f bin/* *.md LICENSE /var/cache/apk/*

COPY --from=builder /app/FullTCore-file/* ./bin/
# gost binary
COPY --from=builder /bin/gost /bin/gost

RUN  chmod -R +x .
ENTRYPOINT ["sh", "main.sh"]

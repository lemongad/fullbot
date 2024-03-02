FROM airportr/fulltclash:alpine AS compile-image

FROM python:3.11.7-alpine3.19

ENV GIT_Branch=dev
ENV TZ=Asia/Shanghai
ENV admin=12345678
ENV api_id=123456
ENV api_hash=ABCDEFG
ENV bot_token=123456:ABCDEFG
ENV branch=meta
ENV core=4
ENV startup=1124
ENV speednodes=300
ENV speedthread=4
ENV nospeed=true

WORKDIR /app

RUN apk add --no-cache \
    git tzdata curl jq wget bash nano && \
    git clone -b $GIT_Branch --single-branch --depth=1 https://github.com/AirportR/FullTclash.git /app && \
    git clone --single-branch --depth=1 https://github.com/twitter/twemoji.git /app/resources/emoji/twemoji && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    echo "00 6 * * * bash /app/docker/update.sh" >> /var/spool/cron/crontabs/root && \
    mkdir /etc/supervisord.d && \
    mv /app/docker/supervisord.conf /etc/supervisord.conf && \
    mv /app/docker/fulltclash.conf /etc/supervisord.d/fulltclash.conf && \
    wget https://github.com/AirportR/FullTCore/releases/download/v1.2-meta/FullTCore_1.2-meta_linux_amd64.tar.gz && tar -xzf FullTCore_1.2-meta_linux_amd64.tar.gz && mv FullTCore ./bin/fulltclash-meta && \
    chmod +x /app/docker/fulltcore.sh && \
    chmod +x ./bin/fulltclash-meta && \
    bash /app/docker/fulltcore.sh && \
    chmod +x /app/docker/update.sh && \
    chmod +x /app/docker/docker-entrypoint.sh

COPY --from=compile-image /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=compile-image /opt/venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

ENTRYPOINT ["/app/docker/docker-entrypoint.sh"]

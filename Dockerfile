#
# Dockerfile for Crontab UI
#

FROM alpine:latest

ENV CRON_PATH /etc/crontabs

RUN set -ex \
  && apk add --update --no-cache \
     curl \
     git \
     nodejs \
     npm \
     supervisor \
     tzdata \
     wget \
  && rm -rf /tmp/* /var/cache/apk/*

WORKDIR /crontab-ui

RUN set -ex \
  && git clone https://github.com/alseambusher/crontab-ui.git . \
  && rm -rf .git* .circleci .dockerignore Dockerfile docker-compose.yml \
  && mv supervisord.conf /etc/supervisord.conf \
  && echo "" > $CRON_PATH/root \
  && chmod +x $CRON_PATH/root

RUN set -ex \
  && npm install

ENV HOST 0.0.0.0
ENV PORT 8000
ENV CRON_IN_DOCKER true

EXPOSE $PORT

CMD ["supervisord", "-c", "/etc/supervisord.conf"]

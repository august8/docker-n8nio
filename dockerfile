FROM node:12.13.0-alpine

LABEL maintainer="august8"

RUN echo "now building ...."

ENV N8N_VERSION=latest

# バージョン指定の有無をチェック
RUN if [ -z "$N8N_VERSION" ] ; then echo "The N8N_VERSION argument is missing!" ; exit 1; fi

# Update everything and install needed dependencies
# RUN apk add --update graphicsmagick tzdata

# # 実行ユーザー
USER root

# Install n8n and the also temporary all the packages
# it needs to build it correctly.
RUN apk --update add --virtual build-dependencies python build-base ca-certificates && \
  npm_config_user=root npm install -g n8n@${N8N_VERSION} && \
  apk del build-dependencies

# 作業ディレクトリ
WORKDIR /data

# 公開ポート
EXPOSE 5678:5678

CMD ["n8n"]

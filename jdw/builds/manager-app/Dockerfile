FROM node:22.12-alpine AS base

# 1. Install dependencies only when needed
FROM base AS deps

ARG USER_ID
ARG GROUP_ID

# Check https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine to understand why libc6-compat might be needed.
RUN apk add --no-cache --upgrade libc6-compat bash

RUN mkdir -m 775 -p /.cache && \
    mkdir -m 775 -p /.npm

RUN npm install -y -g npm@11 -D @swc/cli @swc/core

WORKDIR /app
EXPOSE 80 443
ENV PORT=8080

COPY ./entrypoint.sh /etc/entrypoint.sh
RUN ["chmod", "+x", "/etc/entrypoint.sh"]

#ENTRYPOINT ["/etc/entrypoint.sh"]



FROM node:20.19.6-bookworm-slim AS base

# 1. Install dependencies only when needed
FROM base AS deps

ARG USER_ID
ARG GROUP_ID

RUN #apk add --no-cache bash curl jq sudo \
RUN apk add --no-cache curl jq \
    && addgroup --system --gid $GROUP_ID nodejs \
    && adduser --system --uid $USER_ID nextjs

RUN mkdir -m 775 -p /.cache && \
    mkdir -m 775 -p /.npm

RUN npm install -y -g npm@11 -D @swc/cli @swc/core

WORKDIR /app
EXPOSE 80 443
ENV PORT=80

COPY ./entrypoint.sh /etc/entrypoint.sh
RUN ["chmod", "+x", "/etc/entrypoint.sh"]

#ENTRYPOINT ["/etc/entrypoint.sh"]



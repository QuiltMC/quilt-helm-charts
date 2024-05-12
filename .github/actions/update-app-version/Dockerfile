FROM alpine:3.10

WORKDIR /github/workspace

ARG YQ_VERSION=v4.44.1
ARG YQ_BINARY=yq_linux_amd64

RUN apk add --no-cache wget \
    && wget https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/${YQ_BINARY} -O /usr/bin/yq \
    && chmod +x /usr/bin/yq

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

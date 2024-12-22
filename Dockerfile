# syntax=docker/dockerfile:1.4

FROM golang:1.23.1-alpine3.19 as builder

RUN \
    apk add --update --no-cache \
      curl \
      g++ \
      git \
      make

WORKDIR /opt/rolesanywhere-credential-helper

RUN \
    git clone \
      --depth=1 \
      --branch=v1.4.0 \
      'https://github.com/aws/rolesanywhere-credential-helper.git' \
      . \
    && CGO_ENABLED=1 make -j $(nproc) release

WORKDIR /opt/awscli

RUN \
    curl -fsL 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' -o /tmp/awscliv2.zip \
    && cd /tmp \
    && unzip /tmp/awscliv2.zip \
    && ./aws/install --bin-dir /usr/local/bin --install-dir /opt/awscli \
    && rm -fr /tmp/aws /tmp/awscliv2.zip


FROM alpine:3.19

COPY --from=builder --chown=root:root --chmod=0755 /opt/rolesanywhere-credential-helper/build/bin/aws_signing_helper /bin

COPY --from=builder --chown=root:root /opt/awscli /opt/awscli

# FIXME: checking symlinks first, then copy only relevant ones
COPY --from=builder --chown=root:root /usr/local/bin /usr/local/bin2

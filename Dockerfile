# syntax=docker/dockerfile:1.4

FROM golang:1.23.1-alpine3.19 as builder

WORKDIR /opt/rolesanywhere-credential-helper

RUN \
    apk add --update --no-cache curl g++ git make \
    && git clone \
      --depth=1 \
      --branch=v1.4.0 \
      'https://github.com/aws/rolesanywhere-credential-helper.git' \
      . \
    && CGO_ENABLED=1 make -j $(nproc) release


FROM alpine:3.19

COPY --from=builder --chown=root:root --chmod=0755 /opt/rolesanywhere-credential-helper/build/bin/aws_signing_helper /bin

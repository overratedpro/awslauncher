# syntax=docker/dockerfile:1.4

FROM golang:1.23.1-alpine3.19

WORKDIR /opt/rolesanywhere-credential-helper


RUN \
    apk add --update --no-cache curl git make \
    && git clone \
      --depth=1 \
      --branch=v1.4.0 \
      'https://github.com/aws/rolesanywhere-credential-helper.git' \
      . \
    && CGO_ENABLED=1 make -j $(nproc) release

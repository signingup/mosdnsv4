FROM ubuntu:22.04 AS base

RUN apt-get update && apt-get install -y git

WORKDIR /workspace/easymosdns
RUN git clone https://github.com/signingup/easymosdns.git .

WORKDIR /workspace/mosdns
RUN git clone https://github.com/pmkol/mosdns.git .

FROM golang:1.22.4-alpine AS builder

COPY --from=base /workspace/mosdns /mosdns

#build mosdns
WORKDIR /mosdns

RUN go mod download
RUN go build -o /go/bin/mosdns

FROM alpine:latest

RUN apk add --no-cache git tzdata dcron openrc bash nano curl ca-certificates net-tools bind-tools

COPY --from=builder /go/bin/. /usr/local/bin/
COPY --from=base /workspace/easymosdns /etc/mosdns

COPY ./entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

ENV TZ=UTC
RUN cp /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

EXPOSE 53
EXPOSE 9080

CMD ["/usr/bin/entrypoint.sh"]
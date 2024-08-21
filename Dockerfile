FROM golang:1.23-alpine AS builder

RUN apk update && apk add --no-cache git

WORKDIR /easymosdns
RUN git clone https://github.com/signingup/easymosdns.git . && rm -rf .git

WORKDIR /mosdns
RUN git clone https://github.com/pmkol/mosdns.git .

#build mosdns
RUN go mod download
RUN go build -o /go/bin/mosdns

FROM alpine:latest

RUN apk add --no-cache git tzdata dcron openrc bash nano curl ca-certificates net-tools bind-tools

COPY --from=builder /go/bin/. /usr/local/bin/
COPY --from=builder /easymosdns /etc/mosdns

COPY ./entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

ENV TZ=UTC
RUN cp /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN echo "16 3 * * * /etc/mosdns/rules/update-cdn" > /etc/crontabs/root

EXPOSE 53
EXPOSE 9080

CMD ["/usr/bin/entrypoint.sh"]

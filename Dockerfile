FROM alpine:3

RUN apk add --no-cache chrony

EXPOSE 123/udp

ENTRYPOINT ["chronyd", "-d", "-x", "-u", "root"]

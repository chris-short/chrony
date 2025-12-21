FROM alpine:3

RUN addgroup -S chrony && adduser -S -G chrony chrony \
    && apk add --no-cache chrony

EXPOSE 123/udp

ENTRYPOINT ["chronyd", "-d", "-s", "-u", "chrony:chrony"]

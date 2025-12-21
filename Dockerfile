FROM alpine:3

RUN apk add --no-cache chrony tzdata \
    && rm -rf /var/cache/apk/*

EXPOSE 123/udp

ENTRYPOINT ["chronyd", "-d", "-s"]

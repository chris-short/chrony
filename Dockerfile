FROM alpine:3

RUN apk add --no-cache chrony && \
    mkdir -p /var/lib/chrony /var/log/chrony /run/chrony && \
    chown -R chrony:chrony /var/lib/chrony /var/log/chrony /run/chrony

COPY chrony.conf /etc/chrony/chrony.conf

VOLUME ["/var/lib/chrony"]

EXPOSE 123/udp 323/udp

USER chrony

CMD ["chronyd", "-d", "-f", "/etc/chrony/chrony.conf"]

FROM alpine:3

# Install chrony
RUN apk add --no-cache chrony

# Create necessary directories for chrony runtime data
RUN mkdir -p /var/lib/chrony /var/log/chrony /run/chrony && \
    chown -R chrony:chrony /var/lib/chrony /var/log/chrony /run/chrony && \
    chmod 750 /var/lib/chrony /var/log/chrony

# Copy custom chrony configuration
COPY chrony.conf /etc/chrony/chrony.conf

# Expose NTP port
EXPOSE 123/udp

# Run chronyd in foreground (-d), without setting system clock initially (-x)
# -f specifies config file location
ENTRYPOINT ["chronyd", "-d", "-x", "-f", "/etc/chrony/chrony.conf", "-u", "chrony"]

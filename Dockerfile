FROM alpine:3

# Build-time arguments for dynamic labels
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

# Static labels
LABEL org.opencontainers.image.title="Chrony NTP Server"
LABEL org.opencontainers.image.description="Chrony NTP daemon in Alpine Linux container"
LABEL org.opencontainers.image.authors="Chris Short <chrisshort@duck.com>"
LABEL org.opencontainers.image.url="https://github.com/chris-short/chrony"
LABEL org.opencontainers.image.source=https://github.com/chris-short/chrony
LABEL org.opencontainers.image.documentation="https://github.com/chris-short/chrony#readme"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.vendor="Chris Short"
LABEL org.opencontainers.image.base.name="alpine:3"

# Dynamic labels (set at build time)
LABEL org.opencontainers.image.created=$BUILD_DATE
LABEL org.opencontainers.image.revision=$VCS_REF
LABEL org.opencontainers.image.version=$VERSION

# Cache-bust argument to ensure fresh packages on each build
ARG CACHE_BUST

# Install chrony and apply all available security patches
RUN apk upgrade --no-cache && \
    apk add --no-cache chrony

# Create necessary directories for chrony runtime data
RUN mkdir -p /var/lib/chrony /var/log/chrony /run/chrony && \
    chown -R chrony:chrony /var/lib/chrony /var/log/chrony /run/chrony && \
    chmod 750 /var/lib/chrony /var/log/chrony /run/chrony

# Copy custom chrony configuration
COPY chrony.conf /etc/chrony/chrony.conf

# Expose NTP port
EXPOSE 123/udp

# Run chronyd in foreground (-d), without setting system clock initially (-x)
# -f specifies config file location
ENTRYPOINT ["chronyd", "-d", "-x", "-f", "/etc/chrony/chrony.conf", "-u", "chrony"]

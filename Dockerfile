FROM alpine:3.19

RUN apk add --no-cache \
    curl \
    bash \
    ca-certificates \
    socat \
    tzdata \
    sqlite \
    nginx \
    gettext \
    && ln -sf /usr/share/zoneinfo/Asia/Tehran /etc/localtime

# دانلود و نصب آخرین نسخه 3x-ui از گیت‌هاب
RUN LATEST_TAG=$(curl -s https://api.github.com/repos/mhsanaei/3x-ui/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/') \
    && echo "Installing 3x-ui version: ${LATEST_TAG}" \
    && curl -L "https://github.com/mhsanaei/3x-ui/releases/download/${LATEST_TAG}/x-ui-linux-amd64.tar.gz" -o /tmp/x-ui.tar.gz \
    && tar -xzf /tmp/x-ui.tar.gz -C /usr/local/ \
    && rm /tmp/x-ui.tar.gz \
    && chmod +x /usr/local/x-ui/x-ui

RUN mkdir -p /etc/x-ui /var/log/x-ui

COPY nginx.conf.template /etc/nginx/nginx.conf.template
COPY html /usr/share/nginx/html
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]

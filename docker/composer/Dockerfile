FROM composer:2

# Install ext-bcmath whether base is Alpine or Debian
ARG DEBIAN_FRONTEND=noninteractive
RUN if command -v apk >/dev/null 2>&1; then \
      apk add --no-cache $PHPIZE_DEPS && \
      docker-php-ext-install bcmath && \
      apk del --no-network $PHPIZE_DEPS; \
    elif command -v apt-get >/dev/null 2>&1; then \
      apt-get update && \
      apt-get install -y --no-install-recommends $PHPIZE_DEPS && \
      docker-php-ext-install bcmath && \
      apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false && \
      rm -rf /var/lib/apt/lists/*; \
    else \
      echo "Unsupported base image (no apk/apt-get)"; exit 1; \
    fi

WORKDIR /app

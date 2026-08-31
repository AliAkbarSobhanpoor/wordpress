FROM wordpress:php8.1-apache

# Detect architecture and download the matching ionCube loader
RUN set -eux; \
    ARCH=$(uname -m); \
    if [ "$ARCH" = "x86_64" ]; then \
        IONCUBE_ARCH="x86-64"; \
    elif [ "$ARCH" = "aarch64" ]; then \
        IONCUBE_ARCH="aarch64"; \
    else \
        echo "Unsupported architecture: $ARCH"; exit 1; \
    fi; \
    apt-get update && apt-get install -y --no-install-recommends wget && \
    wget -q https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_${IONCUBE_ARCH}.tar.gz -O /tmp/ioncube.tar.gz && \
    tar -xzf /tmp/ioncube.tar.gz -C /tmp && \
    PHP_EXT_DIR=$(php -r "echo ini_get('extension_dir');") && \
    cp /tmp/ioncube/ioncube_loader_lin_8.1.so "$PHP_EXT_DIR"/ioncube.so && \
    echo "zend_extension=$PHP_EXT_DIR/ioncube.so" > /usr/local/etc/php/conf.d/00-ioncube.ini && \
    rm -rf /tmp/ioncube* && \
    apt-get purge -y wget && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*
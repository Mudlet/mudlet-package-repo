FROM mileschou/lapis:alpine

RUN set -xe && \
        apk add --no-cache --virtual .build-deps \
            gcc \
            g++ \
            git \
            make \
            openssl-dev \
            pcre-dev \
            perl \
            php-fpm \
            zlib-dev \
            linux-headers

RUN set -xe && \
  docker-luarocks-install bcrypt && \
  docker-luarocks-install i18n && \
  docker-luarocks-install lua-resty-mail && \
  docker-luarocks-install inspect

RUN apk del .build-deps

# Set the working directory
WORKDIR /usr/src/app

COPY . .

EXPOSE 8080

CMD lapis migrate $LAPIS_ENVIRONMENT && lapis server $LAPIS_ENVIRONMENT


# Add support for Certbot's SSL certificates
RUN mkdir -p /usr/local/share/ca-certificates
ADD fullchain.pem /usr/local/share/ca-certificates
ADD privkey.pem /usr/local/share/ca-certificates
RUN chmod 644 /usr/local/share/ca-certificates/fullchain.pem
RUN chmod 644 /usr/local/share/ca-certificates/privkey.pem
RUN update-ca-certificates


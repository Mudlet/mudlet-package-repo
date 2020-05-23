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
            zlib-dev \
            linux-headers

RUN set -xe && \
  docker-luarocks-install --verbose bcrypt && \
  docker-luarocks-install --verbose i18n && \
  docker-luarocks-install --verbose lua-resty-mail && \
  docker-luarocks-install --verbose mailgun

RUN apk del .build-deps

# Set the working directory
WORKDIR /usr/src/app

COPY . .

EXPOSE 8080

CMD lapis migrate kubernetes --trace && lapis server kubernetes

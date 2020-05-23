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
  docker-luarocks-install bcrypt && \
  docker-luarocks-install i18n && \
  docker-luarocks-install lua-resty-mail && \
  docker-luarocks-install mailgun

RUN apk del .build-deps

# Set the working directory
WORKDIR /usr/src/app

COPY . .

EXPOSE 8080

CMD lapis migrate kubernetes && lapis server kubernetes

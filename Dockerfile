FROM mileschou/lapis:alpine

RUN set -xe && \
        # Install build deps
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
  # Install build deps
  docker-luarocks-install --verbose bcrypt && \
  docker-luarocks-install --verbose i18n && \
  docker-luarocks-install --verbose lua-resty-mail

RUN apk del .build-deps

# Set the working directory.
WORKDIR /usr/src/app

COPY . .

# Inform Docker that the container is listening on the specified port at runtime.
EXPOSE 8080


# Run the specified command within the container.
CMD [ "lapis", "server" ]

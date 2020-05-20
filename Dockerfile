# alpine can't work due to https://github.com/mikejsavage/lua-bcrypt/issues/11
FROM mileschou/lapis:latest

RUN apt-get update -y && \
  apt-get install unzip build-essential wget -y --no-install-recommends

RUN set -xe && \
  # Install build deps
  docker-luarocks-install --verbose bcrypt && \
  docker-luarocks-install --verbose i18n && \
  docker-luarocks-install --verbose lua-resty-mail

# Set the working directory.
WORKDIR /usr/src/app

COPY . .

# Inform Docker that the container is listening on the specified port at runtime.
EXPOSE 8080


# Run the specified command within the container.
CMD [ "lapis", "server" ]

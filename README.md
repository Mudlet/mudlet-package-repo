# Mudlet Package Repo
This server will power the Mudlet package repository and serve as a reference implementation for any other person or organization which may want to host their own repository for Mudlet packages.

It is implemented using [Lapis](https://leafo.net/lapis/), which is a lua web framework that runs inside of OpenResty (https://openresty.org/en/), a custom implementation of NginX. We make use of the follow luarocks:

* lapis https://github.com/leafo/lapis
* bcrypt http://github.com/mikejsavage/lua-bcrypt
* i18n https://github.com/kikito/i18n.lua
* lua-resty-mail https://github.com/GUI/lua-resty-mail
* lua-mailgun https://github.com/leafo/lua-mailgun

We do not actually make use of lapis-chan, but it served as an example from which examples and inspiration were drawn: https://github.com/karai17/lapis-chan

# Getting started with development

## Via Docker

By choosing Docker you don't have to worry about installing and configuring the dependencies or PostgreSQL yourself.


* Install [Docker](https://docs.docker.com/engine/install/)
* Install [docker-compose](https://docs.docker.com/compose/install/)
* Setup SMTP on localhost at port 1025. You can use [fakeSMTP](http://nilhcem.com/FakeSMTP/) for this as it saves the email as a .eml file and you can open it in your email client of choice - run it with `java -jar fakeSMTP-2.0.jar -p 1025 -o /tmp`.
* Run `docker-compose build` to build the image.
* Run `docker-compose up` to run the website.

To refresh the website, rebuild and re-run it again.

To delete all data and restart from scratch, `docker-compose rm` and `docker volume rm mudlet-package-repo_postgres`.

## Via local development

* Install [OpenResty](https://openresty.org/en/installation.html)
* Install [Luarocks](https://github.com/luarocks/luarocks/wiki/Download)
* `sudo apt install libssl-dev` (on Ubuntu)
* `luarocks install lapis`
* `luarocks install bcrypt`
* `luarocks install i18n`
* `luarocks install mailgun`
* `luarocks install lua-resty-mail`

* Install and configure [PostgreSQL](https://www.postgresql.org/download/). Create `mudletrepo` user, password, and database in plsql ([instructions](https://medium.com/coding-blocks/creating-user-database-and-adding-access-on-postgresql-8bfcd2f4a91e)). Check the development config in [config.lua](config.lua) for defaults currently in use during development.

* create a `data` folder (at the root of the repository)

* run `lapis migrate` to perform the migrations on the database and get it setup

* Setup SMTP on localhost at port 1025. You can use [fakeSMTP](http://nilhcem.com/FakeSMTP/) for this as it saves the email as a .eml file and you can open it in your email client of choice - run it with `java -jar fakeSMTP-2.0.jar -p 1025 -o /tmp`.

Finally, start the server with run `lapis server` and visit http://localhost:8080 to see the page!

The code cache is currently turned off, so refreshing the page will show any changes to the code immediately.

Submit changes via PR, and happy hacking!

# Translation
We are using the i18n module by kikito for internationalization. https://github.com/kikito/i18n.lua

In the static/i18n folder in the project there are several .lua files for i18n translations. If you look in en.lua all of the string keys which are in use through the site are listed, and adding the corresponding key to the de.lua file for instance will add the German translation. Then when the locale is loaded it will load the entries from the language which matches the locale set by the user. If the key isn't found in that locale (en-US for instance) then it will move to the parent locale (en in the example case). If it still doesn't find an entry for that key, it will look in the default (en in our case) and load that. TODO: Figure out getting this in crowdin like Mudlet.

# Mudlet Package Repo
This server will power the Mudlet package repository and server as a reference implementation for any other person or organization which may want to host their own repository for Mudlet packages. 

It is implemented using lapis, which is a lua web framework that runs inside of OpenResty (https://openresty.org/en/), a custom implementation of NginX. We make use of the follow luarocks:

* lapis https://github.com/leafo/lapis
* luacrypto https://github.com/luaforge/luacrypto
* bcrypt http://github.com/mikejsavage/lua-bcrypt
* i18n https://github.com/kikito/i18n.lua
* lua-resty-mail https://github.com/GUI/lua-resty-mail

We do not actually make use of lapis-chan, but it served as an example from which examples and inspiration were drawn: https://github.com/karai17/lapis-chan
The eventual aim is to have it available as a docker container which can read a config.lua file and start the server up. Currently it's being worked on locally using a local postgresql database.

# Getting Started with Development

* Install [OpenResty](https://openresty.org/en/installation.html)
* Install [Luarocks](https://github.com/luarocks/luarocks/wiki/Download)
* `luarocks install lapis`
* `luarocks install luacrypto`
* `luarocks install bcrypt`
* `luarocks install i18n`
* `luarocks install lua-resty-mail`

* Install and configure [PostgreSQL](https://www.postgresql.org/download/). Create `mudletrepo` user, password, and database in plsql ([instructions](https://medium.com/coding-blocks/creating-user-database-and-adding-access-on-postgresql-8bfcd2f4a91e)). Check the development config in [config.lua](config.lua) for defaults currently in use during development.

* run `lapis migrate` to perform the migrations on the database and get it setup

* Setup SMTP on localhost at port 1025. You can use [fakeSMTP](http://nilhcem.com/FakeSMTP/) for this as it saves the email as a .eml file and you can open it in your email client of choice - run it with `java -jar fakeSMTP-2.0.jar -p 1025 -o /tmp`.

Finally, start the server with run `lapis server` and visit http://localhost:8080 to see the page!

The code cache is currently turned off, so refreshing the page will show any changes to the code immediately. 

Submit changes via PR, and happy hacking!

# Translation
We are using the i18n module by kikito for internationalization. https://github.com/kikito/i18n.lua

In the static/i18n folder in the project there are several .lua files for i18n translations. If you look in en.lua all of the string keys which are in use through the site are listed, and adding the corresponding key to the de.lua file for instance will add the German translation. Then when the locale is loaded it will load the entries from the language which matches the locale set by the user. If the key isn't found in that locale (en-US for instance) then it will move to the parent locale (en in the example case). If it still doesn't find an entry for that key, it will look in the default (en in our case) and load that. TODO: Figure out getting this in crowdin like Mudlet.

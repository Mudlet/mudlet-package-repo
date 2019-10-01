# Mudlet Package Repo
This server will power the Mudlet package repository and server as a reference implementation for any other person or organization which may want to host their own repository for Mudlet packages. 

It is implemented using lapis, which is a lua web framework that runs inside of OpenResty, a custom implementation of NginX. It makes use of the follow luarocks:

* lapis
* luacrypto
* bcrypt
* i18n

The eventual aim is to have it available as a docker container which can read a config.lua file and start the server up. Currently it's being worked on locally using a local postgresql database.

# Getting Started with Development

* Install OpenResty
* Install luarocks
* luarocks install lapis
* luarocks install luacrypto
* luarocks install bcrypt
* luarocks install i18n

* Install and configure postgresql. Create mudletrepo user, password, and database in plsql. Check the development config in config.lua for defaults currently in use during development. TODO: put exact plsql commands to run here

* run `lapis migrate` to perform the migrations on the database and get it setup

To start the server run `lapis server` and visit http://localhost:8080 to see the page. 

The code cache is currently turned off, so refreshing the page will show any changes to the code immediately. 

Submit changes via PR, and happy hacking!
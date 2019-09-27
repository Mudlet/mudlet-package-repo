--config.lua
local config = require("lapis.config")
config({'development'}, {
  postgres = {
    database = "mudletrepo",
    user = "mudletrepo",
    password = "pleasechangeme"
  }, 
  secret = "pleasechangeme",
})
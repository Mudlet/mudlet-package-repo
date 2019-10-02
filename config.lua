--config.lua
local config = require("lapis.config")
config({'development'}, {
  postgres = {
    database = "mudletrepo",
    user = "mudletrepo",
    password = "pleasechangeme"
  }, 
  secret = "pleasechangeme",
  salt = "12",
  body_size = "10m",
  num_workers = 2,
})

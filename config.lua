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
  data_dir = "data",
  smtp_host = "127.0.0.1",
  smtp_port = 25,
  sender_address = "do-not-reply@mudlet.org",
  admin_email = "demonnic@gmail.com",
  admin_password = "supersecretadminpass", -- this can be removed once you've viewed the page for the first time
  base_url = "http://localhost:8080/",
})

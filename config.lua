--config.lua
local config = require("lapis.config")
config({'development', 'docker', 'kubernetes'}, {
  postgres = {
    database = "mudletrepo",
    user = "mudletrepo",
    password = "pleasechangeme"
  },
  secret = "pleasechangeme",
  salt = "12",
  body_size = "20m",
  num_workers = 2,
  data_dir = "data",
  smtp_host = "127.0.0.1",
  smtp_port = 1025,
  sender_address = "do-not-reply@mudlet.org",
  admin_email = "demonnic@gmail.com",
  admin_password = "supersecretadminpass", -- this can be removed once you've viewed the page for the first time
  base_url = "http://localhost:8080/",
  website_name = "Mudlet Package Repository (experimental)"
})

config({'development', {
  resolver_address = '8.8.8.8',
}})

config({'docker'}, {
  -- need to use docker resolver inside docker
  resolver_address = '127.0.0.11',
  postgres = {
    host = "psql"
  }
})

config({'kubernetes'}, {
  resolver_address = '8.8.8.8',
  -- to be fixed with a DNS when that is hooked up, for now has to be hardcoded
  base_url = "http://45.79.247.15:8080/",
  postgres = {
    host = "10.128.61.7"
  }
})

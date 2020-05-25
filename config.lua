-- any environment variables used here must also be declared in nginx.conf
local config = require("lapis.config")
config({'development', 'docker'}, {
  postgres = {
    database = "mudletrepo",
    user = "mudletrepo",
    password = "pleasechangeme"
  },
  secret = "pleasechangeme",
  custom_resolver = "",
  salt = "12",
  body_size = "20m",
  num_workers = 2,
  data_dir = "data",
  smtp_host = "127.0.0.1",
  smtp_port = 1025,
  sender_address = "do-not-reply@mudlet.org",
  use_mailgun = false,
  mailgun_api_key = "",
  admin_email = "demonnic@gmail.com",
  admin_password = "supersecretadminpass", -- this can be removed once you've viewed the page for the first time
  base_url = "http://localhost:8080/",
  website_name = "Mudlet Package Repository (experimental)"
})

config({'docker'}, {
  -- need to use docker resolver inside docker
  custom_resolver = 'resolver 127.0.0.11 ipv6=off;',
  postgres = {
    host = "psql"
  },
  code_cache = "on",
  use_mailgun = false,
  mailgun_api_key = os.getenv("MAILGUN_API_KEY")
})

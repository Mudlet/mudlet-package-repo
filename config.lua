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
  session_name = "mudlet-package-repo-session",
  salt = "12",
  body_size = "20m",
  num_workers = 2,
  data_dir = "data",
  smtp_host = "127.0.0.1",
  smtp_port = 1025,
  smtp_username = nil,
  smtp_password = nil,
  sender_address = "do-not-reply@mudlet.org",
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
  smtp_host = os.getenv("SMTP_HOST"),
  smtp_port = os.getenv("SMTP_PORT"),
  smtp_username = os.getenv("SMTP_USERNAME"),
  smtp_password = os.getenv("SMTP_PASSWORD")
})

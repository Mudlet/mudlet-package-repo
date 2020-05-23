--config.lua
local config = require("lapis.config")
local inspect = require("inspect")

print("BASE URL: "..tostring(os.getenv("REPO_BASE_URL")))
print("LAPIS_ENVIRONMENT: "..tostring(os.getenv("LAPIS_ENVIRONMENT")))

config({'development', 'docker', 'kubernetes'}, {
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
  code_cache = "on"
})

config({'kubernetes'}, {
  base_url = os.getenv("REPO_BASE_URL"),
  custom_resolver = 'resolver kube-dns.kube-system.svc.cluster.local;',
  postgres = {
    host = "psql.default.svc.cluster.local"
  },
  code_cache = "on",
  use_mailgun = true,
  mailgun_api_key = os.getenv("MAILGUN_API_KEY")
})

print(inspect(config.get()))

local lapis = require("lapis")
local respond_to = lapis.application.respond_to
local app = lapis.Application()
local config = require("lapis.config").get()
local db = require("lapis.db")
local Model = require("lapis.db.model").Model
local Users = require("models.users")
local Packages = require("models.packages")
local login = require("controllers.login")
local register = require("controllers.register")

app:enable("etlua")
app.layout = require('views.layout')
-- base route
app:get("index", "/", function(self)
  local name = self.session.name or "unknown"
  return "Hello there, " .. name
end)

app:get("/user", function(self)
  local u = Users:get_user("demonnic")
  if u then return "Hello there " .. u.name end
end)

app:get("/packages", function()
  local packages = db.select("* from packages")
  return { json = packages}
end)

app:match("login", "/login", respond_to(login))

app:get("/getuser1packages", function(self)
  local user = Users:find(1)
  local packages = user:get_packages()
  return {json = packages}
end)

-- new user route
app:match("register", "/register", respond_to(register))

app:get("newpackage", "/newpackage", function(self)
  local package = Packages:create({
    name = self.params.name,
    version = self.params.version,
    description = self.params.description or "",
    user_id = self.params.user_id or 1,
    extension = self.params.extension or "xml",
  })
  if package then return "Package " .. self.params.name .. " created!" end
end)

return app
local lapis = require("lapis")
local app = lapis.Application()
local config = require("lapis.config").get()
local db = require("lapis.db")
local Model = require("lapis.db.model").Model
local Users = require("models.users")
local Packages = require("models.packages")


-- base route
app:get("/", function()
  local users = db.select("* from users")
  return { json = users }
end)

app:get("/packages", function()
  local packages = db.select("* from packages")
  return { json = packages}
end)

app:get("/getuser1packages", function(self)
  local user = Users:find(1)
  local packages = user:get_packages()
  return {json = packages}
end)

-- new user route
app:get("newuser", "/newuser", function(self)
  local user = Users:create({
    name = self.params.name,
    email = self.params.email,
  })
end)

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
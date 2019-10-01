local bcrypt = require ("bcrypt")
local config   = require("lapis.config").get()
local token = config.secret
local trim = require("lapis.util").trim_filter
local Model = require("lapis.db.model").Model
local Users = Model:extend("users", {
  relations = {
    {"packages", has_many = "Packages"}
  }
})

function Users:create_user(user)
  trim(user, {"name", "password", "admin", "email"}, nil)
  local hash = bcrypt.digest(user.name .. user.password .. token, config.salt)
  user.password = nil
  local user = self:create {
    name = user.name,
    password = hash,
    admin = user.admin,
    email = user.email
  }
  if user then
    return user
  end
  return false, i18n("err_create_user", {user.name})
end

function Users:verify_user(params)
  local user = self:get_user(params.name)
  if not user then
    return false, i18n("err_invalid_user")
  end
  local pass = user.name .. params.password .. token
  params.password = nil
  local verified = bcrypt.verify(pass, user.password)
  pass = nil
  if verified then
    return user
  else
    return false, i18n("err_invalid_user")
  end
end

function Users:get_user(name)
  name = string.lower(name)
  return unpack(self:select("where lower(name)=? limit 1", name))
end

function Users:get_users()
  return self:select("order by name asc")
end

return Users
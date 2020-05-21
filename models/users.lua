local bcrypt = require ("bcrypt")
local config   = require("lapis.config").get()
local token = config.secret
local trim = require("lapis.util").trim_filter
local Model = require("lapis.db.model").Model
local i18n = require("i18n")
local Users = Model:extend("users", {
  relations = {
    {"packages", has_many = "Packages"}
  }
})

local function uuid()
  math.randomseed(os.clock()*1000000)
  local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
  return string.gsub(template, '[xy]', function (c)
    local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
    return string.format('%x', v)
  end)
end

function Users:create_user(user)
  trim(user, {"name", "password", "admin", "email", "verified"}, nil)
  local hash = bcrypt.digest(user.name .. user.password .. token, config.salt)
  local email_verification = uuid()
  user.password = nil
  local user = self:create {
    name = user.name,
    password = hash,
    admin = user.admin,
    email = user.email,
    email_ver_code = email_verification,
    email_verified = user.verified or false,
  }
  if user then
    return user
  end
  return false, i18n("err_create_user", {user.name})
end

function Users:update_password(username, newpassword)
  local user = Users:find({name = username})
  assert(user)

  local hash = bcrypt.digest(user.name .. newpassword .. token, config.salt)

  user:update({password = hash})
end

function Users:verify_user(name, password)
  local user = self:get_user(name)
  if not user then
    return false, i18n("err_invalid_user")
  end
  local pass = user.name .. password .. token
  local verified = bcrypt.verify(pass, user.password)
  pass, password = nil, nil
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

function Users:get_user_by_email(email)
  email = string.lower(email)
  return unpack(self:select("where lower(email)=? limit 1", email))
end

function Users:get_users()
  return self:select("order by name asc")
end

return Users

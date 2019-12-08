local i18n = require("i18n")
local Users = require("models.users")
local app_helpers = require("lapis.application")
local capture_errors,assert_error  = app_helpers.capture_errors, app_helpers.assert_error
local split_string = function(str, delimiter)
  local result = { }
  local from = 1
  local delim_from, delim_to = string.find( str, delimiter, from  )
  while delim_from do
    table.insert( result, string.sub( str, from, delim_from - 1 ) )
    from = delim_to + 1
    delim_from, delim_to = string.find( str, delimiter, from  )
  end
  table.insert( result, string.sub( str, from  ) )
  return result
end
local config = require("lapis.config").get()

return capture_errors(function(self)
  self.split_string = split_string
  self.config = config
  -- check parameters for locale and set in session
  if self.params.locale then
    self.session.locale = self.params.locale
  end
  local detected_locale
  if self.req.headers['accept-language'] then
    detected_locale = self.split_string(self.req.headers['accept-language'], ",")[1]
  end

  -- load in locale files
  i18n.loadFile("static/i18n/en.lua")
  i18n.loadFile("static/i18n/ru.lua")
  i18n.loadFile("static/i18n/de.lua")
  i18n.loadFile("static/i18n/it.lua")

  -- set the actual locale
  i18n.setLocale(self.session.locale or detected_locale or "en")
  self.i18n = i18n
  -- check if the admin users exists
  local admin = Users:get_user('admin')

  -- and if not create it
  if not admin then
    local user_table = {
      name = 'admin',
      password = config.admin_password or "pleasechangeme",
      email = config.admin_email or "admin@example.org",
      verified = true
    }
    assert_error(Users:create_user(user_table))
  else
    admin = nil
  end
  self.burl = function(self,path)
    return config.base_url .. path
  end
end)

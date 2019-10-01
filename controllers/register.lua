local Users = require("models.users")
local validate = require("lapis.validate")
local app_helpers = require("lapis.application")
local capture_errors,assert_error  = app_helpers.capture_errors, app_helpers.assert_error
return {
  GET = capture_errors(function(self)
    return { render = "register" }
  end),
  POST = capture_errors(function(self)
    validate.assert_valid(self.params, {
      { "name", exists = true, min_length = 2, max_length = 25 },
      { "password", exists = true, min_length = 8 },
      { "password_repeat", equals = self.params.password },
      { "email", exists = true, min_length = 5 },
    })
    if self.params.admin == nil then self.params.admin = false end
    local u = Users:get_user(self.params.name)
    if u then 
      assert_error(false, i18n("err_user_exists", {self.params.name}))
    end
    local user = {
      name = self.params.name,
      password = self.params.password,
      email = self.params.email,
      admin = self.params.admin,    
    }
    local u, err = assert_error(Users:create_user(user))
    if u then
      return i18n("user_created")
    end
  end)
}
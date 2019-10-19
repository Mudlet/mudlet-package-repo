local Users = require("models.users")
local app_helpers = require("lapis.application")
local capture_errors,assert_error  = app_helpers.capture_errors, app_helpers.assert_error
return {
  before = capture_errors(function(self)
    self.users = Users:get_users()
    self.page_title = self.i18n("login_nav")
  end),
  GET = capture_errors(function(self)
    return { render = "login" }
  end),
  POST = capture_errors(function(self)
    local user = assert_error(Users:verify_user(self.params.name, self.params.password))
    self.session.name = user.name
    self.session.admin = user.admin
    return "Successfully logged in!"
  end),
}

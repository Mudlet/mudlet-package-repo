local app_helpers = require("lapis.application")
local validate = require("lapis.validate")
local capture_errors, assert_error = app_helpers.capture_errors, app_helpers.assert_error
local Users = require("models.users")

return {
  before = capture_errors(function(self)
    self.page_title = self.i18n("account_nav")
  end),
  GET = capture_errors(function(self)
    assert_error(self.session.name, self.i18n("err_not_logged_in"))
    return { render = "account" }
  end),
  POST = capture_errors(function(self)
    validate.assert_valid(self.params, {
      { "new_password", exists = true, min_length = 8, "Please enter the new password." },
      { "confirm_new_password", equals = self.params.new_password,
            "Make sure your confirmation password matches the new password." },
    })

    self.params.password = self.params.old_password
    self.params.name = self.session.name
    assert_error(Users:verify_user(self.params), "Old password must match.")
    Users:update_password(self.session.name, self.params.new_password)

    return self.i18n("password_updated")
  end)
}

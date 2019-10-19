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
      { "new_password", exists = true, min_length = 8, self.i18n("missing_new_password") },
      { "confirm_new_password", equals = self.params.new_password,
            self.i18n("confirmation_password_must_match") },
    })

    assert_error(Users:verify_user(self.session.name, self.params.old_password), self.i18n("old_password_mismatch"))
    Users:update_password(self.session.name, self.params.new_password)

    return self.i18n("password_updated")
  end)
}

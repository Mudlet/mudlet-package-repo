local Users = require("models.users")
local validate = require("lapis.validate")
local app_helpers = require("lapis.application")
local capture_errors,assert_error  = app_helpers.capture_errors, app_helpers.assert_error
return {
  GET = capture_errors(function(self)
    if self.params.email and self.params.ver_code then
      local user = Users:get_user_by_email(self.params.email)
      assert_error(self.params.ver_code == user.email_ver_code, self.i18n("verification_mismatch"))
      assert_error(user:update({email_verified = true}))
      if self.session.name == user.name then
        self.session.verified = user.email_verified
      end
      return self.i18n("verification_success")
    else
      return { render = true }
    end
  end),
  POST = capture_errors(function(self)
    validate.assert_valid(self.params, {
      { "email", exists = true },
      { "ver_code", exists = true}
    })
    local user = Users:get_user_by_email(self.params.email)
    assert_error(self.params.ver_code == user.email_ver_code, self.i18n("verification_mismatch"))
    assert_error(user:update({email_verified = true}))
    if self.session.name == user.name then
      self.session.verified = user.email_verified
    end
    return self.i18n("verification_success")
  end)
}

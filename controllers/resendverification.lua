local Users = require("models.users")
local app_helpers = require("lapis.application")
local capture_errors,assert_error  = app_helpers.capture_errors, app_helpers.assert_error
local mail = require("controllers.mail")

return {
  GET = capture_errors(function(self)
    local name = self.session.name
    --if name then return name end
    local user,err = Users:get_user(name)
    assert_error(user,err)
    mail:send_verification(user,self.i18n)
    return self.i18n("resend_verification_success")
  end)
}

local Users = require("models.users")
local validate = require("lapis.validate")
local app_helpers = require("lapis.application")
local capture_errors,assert_error  = app_helpers.capture_errors, app_helpers.assert_error
local mail = require("resty.mail")
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
      assert_error(false, self.i18n("err_user_exists", {self.params.name}))
    end
    local user = {
      name = self.params.name,
      password = self.params.password,
      email = self.params.email,
      admin = self.params.admin,    
    }
    local u = assert_error(Users:create_user(user))
    if u then
      local ver_code = u.email_ver_code
      local alternate_url = string.format("%sverifyemail", self.config.base_url)
      local url = string.format("%s?ver_code=%s&email=%s", alternate_url, ver_code, u.email)
      local message_body = self.i18n("verify_email_body", {u.name, base_url, url, alternate_url, ver_code})
      local message_subject = self.i18n("verify_email_subject", {self.i18n("website_name")})

      local mailer, err = mail.new({
        host = self.config.smtp_host or "smtp.gmail.com",
        port = self.config.smtp_port or 25,
      })
      assert_error(mailer, err)
      local ok,err = mailer:send({
        from = self.config.sender_address,
        to = {string.format("%s <%s>", u.name, u.email)},
        subject = message_subject,
        text = message_body
      })
      assert_error(ok,err)
      return self.i18n("user_created")
    end
  end)
}

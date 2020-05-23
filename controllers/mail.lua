local app_helpers = require("lapis.application")
local assert_error  = app_helpers.assert_error
local mail_handler = require("resty.mail")
local mail = {
  config = require("lapis.config").get()
}

function mail:send(subject, body, user)
  if not self.config.use_mailgun then
    local mailer, err = mail_handler.new({
      host = self.config.smtp_host or "smtp.gmail.com",
      port = self.config.smtp_port or 25,
    })
    assert_error(mailer, string.format("Couldn't connect to the email service: %s", err))
    local ok,err = mailer:send({
      from = self.config.sender_address,
      to = {string.format("%s <%s>", user.name, user.email)},
      subject = subject,
      text = body
    })
    assert_error(ok, string.format("Error sending an email: %s", err))
  else
    assert_error(self.config.mailgun_api_key, "No mailgun API key is configured - can't send email.")

    local Mailgun = require("mailgun").Mailgun
    local m = Mailgun({
      domain = "mudlet.org",
      api_key = self.config.mailgun_api_key
    })

    m:send_email({
      from = self.config.sender_address,
      to = string.format("%s <%s>", user.name, user.email),
      subject = subject,
      html = true,
      body = body
    })
  end
end

function mail:send_verification(user, i18n)
  local ver_code = user.email_ver_code
  local alternate_url = string.format("%sverifyemail", self.config.base_url)
  local url = string.format("%s?ver_code=%s&email=%s", alternate_url, ver_code, user.email)
  local message_body = i18n("verify_email_body", {user.name, self.config.website_name, url, alternate_url, ver_code})
  local message_subject = i18n("verify_email_subject", {self.config.website_name})
  self:send(message_subject, message_body, user)
end

return mail

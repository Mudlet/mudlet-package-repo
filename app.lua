local lapis = require("lapis")
local respond_to = lapis.application.respond_to
local app = lapis.Application()
local config = require("lapis.config").get()
local db = require("lapis.db")
local Model = require("lapis.db.model").Model
local Users = require("models.users")
local Packages = require("models.packages")
local login = require("controllers.login")
local logout = require("controllers.logout")
local register = require("controllers.register")
local uploadpackage = require("controllers.uploadpackage")
local account = require("controllers.account")
local verify_email = require("controllers.verifyemail")
local app_helpers = require("lapis.application")
local resend_verification = require("controllers.resendverification")
local capture_errors, assert_error = app_helpers.capture_errors, app_helpers.assert_error


app:enable("etlua")
app.layout = require('views.layout')

local config_before = require("controllers.config_before")
local check_auth = require("controllers.check_auth")

app:before_filter(config_before)
app:before_filter(check_auth)

-- base route
app:get("index", "/", capture_errors(function(self)
  local name = self.session.name or "unknown"
  return self.i18n("greeting", {name})
end))

app:get("packages", "/packages", capture_errors(function()
  local packages = db.select("* from packages")
  return { json = packages}
end))

app:match("login", "/login", respond_to(login))
app:match("logout", "/logout", logout)
app:match("account", "/account", respond_to(account))
app:match("register", "/register", respond_to(register))
app:match("uploadpackage", "/uploadpackage", respond_to(uploadpackage))
app:match("verifyemail", "/verifyemail", respond_to(verify_email))
app:match("resendverification", "/resendverification", respond_to(resend_verification))

return app

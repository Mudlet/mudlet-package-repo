local app_helpers = require("lapis.application")
local validate = require("lapis.validate")
local capture_errors, assert_error = app_helpers.capture_errors, app_helpers.assert_error
local lfs = require('lfs')
local Packages = require("models.packages")
local Users = require("models.users")

return {
  GET = capture_errors(function(self)
    assert_error(self.session.name, self.i18n("err_not_logged_in"))
    assert_error(self.session.verified, self.i18n("err_email_not_verified"))
    self.myPackages = Packages:get_packages()
    return { render = "changepackage" }
  end),
  POST = capture_errors(function(self)
    -- must be logged in to upload
    assert_error(self.session.name, self.i18n("err_not_logged_in"))
    assert_error(self.session.verified, self.i18n("err_email_not_verified"))

    -- must provide a file, a name, and a version
    validate.assert_valid(self.params, {
      { "name", exists = true, min_length = 2 },
      { "version", exists = true }
      --{ "file", exists = true, is_file = true }
    })

    local user = Users:get_user(self.session.name)
    local findPackage = Packages:find({name = self.params.name})
    local package, err = findPackage:delete()
    assert_error(package, err)
    return "Deleted"
  end)
}

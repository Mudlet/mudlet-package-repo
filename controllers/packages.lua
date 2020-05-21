local app_helpers = require("lapis.application")
local validate = require("lapis.validate")
local capture_errors, assert_error = app_helpers.capture_errors, app_helpers.assert_error
local lfs = require('lfs')
local Packages = require("models.packages")
local Users = require("models.users")
inspect = require("inspect")

return {
  GET = capture_errors(function(self)
    self.packages = Packages:get_packages()
    return { render = true }
  end)
}

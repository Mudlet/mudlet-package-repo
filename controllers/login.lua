local Users = require("models.users")
local assert_error  = require("lapis.application").assert_error
return {
  before = function(self)
    self.users = Users:get_users()
    self.page_title = "Login to MPR"
  end,
  GET = function(self)
    return { render = "login" }
  end,
  POST = function(self)
    local user = assert_error(Users:verify_user(self.params))
    self.session.name = user.name
    self.session.admin = user.admin
    return "Successfully logged in!"
  end,
}
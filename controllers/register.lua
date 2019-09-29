local Users = require("models.users")
local validate = require("lapis.validate")

return {
  GET = function(self)
    return { render = "register" }
  end,
  POST = function(self)
    validate.assert_valid(self.params, {
      { "name", exists = true, min_length = 2, max_length = 25 },
      { "password", exists = true, min_length = 8 },
      { "password_repeat", equals = self.params.password },
      { "email", exists = true, min_length = 5 },
    })
    if self.params.admin == nil then self.params.admin = false end
    local u = Users:get_user(self.params.name)
    if u then 
      return "User already exists, please try again!"
    end
    local user = {
      name = self.params.name,
      password = self.params.password,
      email = self.params.email,
      admin = self.params.admin,    
    }
    local u = Users:create_user(user)
    if u then
      return "User created!"
    else
      return "Something went wrong!"
    end
  end
}
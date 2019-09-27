local Model = require("lapis.db.model").Model
local Users = Model:extend("users", {
  relations = {
    {"packages", has_many = "Packages"}
  }
})

return Users
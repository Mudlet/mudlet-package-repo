local Model = require("lapis.db.model").Model
local Packages = Model:extend("packages")

function Packages:get_packages()
  return self:select("order by user_id asc,name asc")
end

function Packages:get_user_packages(user_id)
  return self:select("where user_id = ?", user_id)
end

-- if user is not admin only the users packages are found
function Packages:find_user_package(name, user_id, isAdmin)
  if isAdmin then
    return self:find({name = name})
  end
  return self:find({name = name, user_id = user_id})
end

return Packages

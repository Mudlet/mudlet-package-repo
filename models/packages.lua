local Model = require("lapis.db.model").Model
local Packages = Model:extend("packages")

function Packages:get_packages()
  return self:select("order by user_id asc,name asc")
end

return Packages

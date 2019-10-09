local Users  = require "models.users"

return function(self)
  
  -- Verify Authorization
	if self.session.name then
		local user = Users:get_user(self.session.name)

		if user then
			user.password = nil
			self.session.admin = user.admin
			self.session.verified = user.email_verified
		else
			self.session.admin = nil
			self.session.verified = nil
		end
	else
		self.session.admin = nil
		self.session.verified = nil
	end
end

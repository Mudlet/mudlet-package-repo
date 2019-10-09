return function(self)
  self.session.name = nil
  self.session.admin = nil
  self.session.verified = nil
  return { redirect_to = self.config.base_url }
end

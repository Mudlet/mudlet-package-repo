local i18n = require("i18n")

return function(self)
  -- load in locale files
  i18n.loadFile("static/i18n/en.lua")
  i18n.loadFile("static/i18n/ru.lua")
  i18n.loadFile("static/i18n/de.lua")
  i18n.loadFile("static/i18n/it.lua")
  self.i18n = i18n
end
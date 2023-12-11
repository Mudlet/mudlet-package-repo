local app_helpers = require("lapis.application")
local validate = require("lapis.validate")
local capture_errors, assert_error = app_helpers.capture_errors, app_helpers.assert_error
local Packages = require("models.packages")
local Users = require("models.users")
local FileUtils = require("helper.fileUtils")

local save_file = FileUtils.save_file

return {
  GET = capture_errors(function(self)
    assert_error(self.session.name, self.i18n("err_not_logged_in"))
    assert_error(self.session.verified, self.i18n("err_email_not_verified"))
    local user = Users:get_user(self.session.name)
    if not user.admin then
      self.myPackages = Packages:get_user_packages(user.id)
    else
      self.myPackages = Packages:get_packages()
    end
    return { render = "changepackage" }
  end),
  POST = capture_errors(function(self)
    -- must be logged in to upload
    assert_error(self.session.name, self.i18n("err_not_logged_in"))
    assert_error(self.session.verified, self.i18n("err_email_not_verified"))
    local user = Users:get_user(self.session.name)
    if not user.admin then
      self.myPackages = Packages:get_user_packages(user.id)
    else
      self.myPackages = Packages:get_packages()
    end

    -- must provide a file, a name, and a version
    validate.assert_valid(self.params, {
      { "name", exists = true, min_length = 2 },
      { "version", exists = true },
    })
    local filename
    if self.params.file.filename ~= "" then
      -- prep some info
      local fname = self.params.file.filename
      local fcontent = self.params.file.content
      local zipheader = "PK"
      local mudlet_xml_header = "<!DOCTYPE MudletPackage>"
      local file_extension = string.match(fname, ".+%.(.+)")
      filename = string.format("%s-%s.%s", self.params.name, self.params.version, file_extension)

      -- validate file extension
      local proper_extension = file_extension and
      (file_extension == "xml" or file_extension == "zip" or file_extension == "mpackage")
      assert_error(proper_extension, self.i18n("err_invalid_file_extension"))

      -- validate the content is proper for the extension claimed
      if file_extension == "mpackage" or file_extension == "zip" then
        assert_error(string.find(fcontent, zipheader) == 1, self.i18n("err_invalid_mpackage"))
      elseif file_extension == "xml" then
        assert_error(string.find(fcontent, mudlet_xml_header), self.i18n("err_invalid_mudlet_xml"))
      end

      -- save the file to disk. function defined above.
      save_file(self)
    end
    local new_url = filename and string.format("%sdata/%s/%s/%s/%s", self.config.base_url, self.session.name, self.params.name, self.params.version, filename)
    local findPackage = Packages:find_user_package(self.params.name, user.id, user.admin)
    if not(self.params.delete) then
      local package, err = findPackage:update({
        version = self.params.version,
        description = self.params.description or "",
        game = self.params.game or "",
        dependencies = self.params.dependencies or "",
        url = new_url or url,
      })
      assert_error(package, err)
      return self.i18n("change_success", {self.params.name})
    else
      local package, err = findPackage:delete()
      assert_error(package, err)
      return self.i18n("delete_success", {self.params.name})
    end
  end)
}

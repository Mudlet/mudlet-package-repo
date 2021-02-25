local app_helpers = require("lapis.application")
local validate = require("lapis.validate")
local capture_errors, assert_error, yield_error =
  app_helpers.capture_errors, app_helpers.assert_error, app_helpers.yield_error
local lfs = require('lfs')
local Packages = require("models.packages")
local Users = require("models.users")

-- if you can change the name of a thing to itself, it is a file or folder
-- best work around I could find for testing this
local function isFileOrDir(name)
  if type(name)~="string" then return false end
  return os.rename(name, name)
end

-- use LFS's chdir() function to determine if the target is a directory
-- there is no check for if something is a file or directory in lua or LFS by default
local function isDir(name)
  if type(name)~="string" then return false end
  local cd = lfs.currentdir()
  local is, err = lfs.chdir(name)
  lfs.chdir(cd)
  return is, err
end

-- If it is no directory, but we can rename it to itself, then it is a file
local function isFile(name)
  if not isDir(name) then
    return os.rename(name,name) and true or false
  end
  return false
end

-- use the above functions to check if the folders exist and
-- create them if they do not.
local function save_file(self)
  -- record our current directory so we can change back to it
  local cwd = lfs.currentdir()
  local file_extension = string.match(self.params.file.filename, ".+%.(.+)")

  -- start in the data directory
  local success, message = lfs.chdir(self.config.data_dir)
  if not success then lfs.chdir(cwd); yield_error("Could not enter data directory: "..message) end

  local handle = io.popen("ps")
  local result = handle:read("*a")
  handle:close()
  print("ps result: "..result)

  -- create username directory if it does not exist, validate it's a dir and enter it
  if not isFileOrDir(self.session.name) then
    local success, message = lfs.mkdir(self.session.name)
    if not success then lfs.chdir(cwd); yield_error("Could not create username directory: "..message) end
  end
  local success, message = lfs.chdir(self.session.name)
  if not success then lfs.chdir(cwd); yield_error("Could not enter username directory: "..message) end

  -- and again for the pkg name
  if not isFileOrDir(self.params.name) then
    local success, message = lfs.mkdir(self.params.name)
    if not success then lfs.chdir(cwd); yield_error("Could not create package directory: "..message) end
  end
  local success, message = lfs.chdir(self.params.name)
  if not success then lfs.chdir(cwd); yield_error("Could not enter package directory: "..message) end

  -- and again for the pkg version
  if not isFileOrDir(self.params.version) then
    local success, message = lfs.mkdir(self.params.version)
    if not success then lfs.chdir(cwd); yield_error("Could not create package version directory: "..message) end
  end
  local success, message = lfs.chdir(self.params.version)
  if not success then lfs.chdir(cwd); yield_error("Could not enter package version directory: "..message) end

  local filename = string.format("%s-%s.%s", self.params.name, self.params.version, file_extension)
  local file, message = io.open(filename, 'w')
  if not file then lfs.chdir(cwd); yield_error("Could not open package file for writing: "..message) end
  file:write(self.params.file.content)
  file:flush()
  file:close()
  local success, message = lfs.chdir(cwd)
  if not success then yield_error("Could not change back to the application's working directory: ".. message) end
end

return {
  GET = capture_errors(function(self)
    assert_error(self.session.name, self.i18n("err_not_logged_in"))
    assert_error(self.session.verified, self.i18n("err_email_not_verified"))
    return { render = "uploadpackage" }
  end),
  POST = capture_errors(function(self)
    -- must be logged in to upload
    assert_error(self.session.name, self.i18n("err_not_logged_in"))
    assert_error(self.session.verified, self.i18n("err_email_not_verified"))

    -- must provide a file, a name, and a version
    validate.assert_valid(self.params, {
      { "name", exists = true, min_length = 2 },
      { "version", exists = true },
      { "file", exists = true, is_file = true }
    })
    -- prep some info
    local fname = self.params.file.filename
    local fcontent = self.params.file.content
    local zipheader = "PK"
    local mudlet_xml_header = "<!DOCTYPE MudletPackage>"
    local file_extension = string.match(fname, ".+%.(.+)")
    local filename = string.format("%s-%s.%s", self.params.name, self.params.version, file_extension)


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
    local url = string.format("%sdata/%s/%s/%s/%s", self.config.base_url, self.session.name, self.params.name, self.params.version, filename)
    local user = Users:get_user(self.session.name)
    local package, err = Packages:create({
      name = self.params.name,
      version = self.params.version,
      description = self.params.description or "",
      game = self.params.game or "",
      dependencies = self.params.dependencies or "",
      user_id = user.id,
      url = url,
      extension = file_extension
    })
    assert_error(package, err)
    return self.i18n("upload_success", {url})
  end)
}

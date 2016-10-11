fs = require 'fs'
path = require 'path'

module.exports = class SettingsManager
  constructor: (@name) ->
    @file = path.resolve(AssetsController.assetsPath, "#{@name}.json")
    if @needsCreating()
      @create()
    @loadSettings()
    @debouncedSave = _.debounce _.bind(@_save, @)
    , 3000, {trailing: true, leading: false}
  needsCreating: ->
    not @fileExists()
  create: ->
    try
      fs.mkdirSync path.dirname(@file),
    catch error
      if error.code is 'EEXIST'
        # this is good
      else
        error 'assetDirectoryError', @file,
         "Could not create user asset file: #{@file}"
        @state = "error"
    fs.writeFileSync @file, '{}', 'utf8'
  fileExists: ->
    fs.existsSync(@file)
  loadSettings: ->
    @settings = JSON.parse(fs.readFileSync(@file, 'utf8'))
    emit "#{@constructor.name}SettingsLoaded", {@file}
  update: (object) ->
    @settings = object
    @save()
  _save: ->
    fs.writeFile @file, JSON.stringify(@settings, null, 4), 'utf8'
    emit "#{@constructor.name}SettingsSaved", {@file}
  save: ->
    @debouncedSave()

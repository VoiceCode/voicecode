fs = require 'fs'
path = require 'path'

module.exports = class SettingsManager
  debouncedSave = null
  constructor: (@name) ->
    @file = path.resolve(AssetsController.assetsPath, "#{@name}.json")
    if @needsCreating()
      @create()
    @loadSettings()
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
         "Could not create user assets directory: #{@file}"
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
    debouncedSave = null
    emit "#{@constructor.name}SettingsSaved", {@file}
  save: ->
    unless debouncedSave?
      debouncedSave = _.debounce _.bind(@_save, @), 1000
    debouncedSave()

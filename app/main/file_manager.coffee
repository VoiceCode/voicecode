fs = require 'fs'
path = require 'path'

module.exports = class FileManager
  instances = {}

  @types: (getter, setter = null) ->
    @_types ?= {}
    if setter?
      @_types = _.assignWith @_types, setter
      , (original, value) -> _.defaults value,
        path: ''
        loader: (data) -> data
        saver: (data) -> data
    @_types[getter] if getter?

  constructor: (@name, @type = 'json') ->
    return instances["#{@name}#{@type}"] if instances["#{@name}#{@type}"]?
    instances["#{@name}#{@type}"] = @

    @type = FileManager.types(@type)
    @file = path.resolve(AssetsController.assetsPath
    , "#{@type.path}#{@name}#{@type.extension}")
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
    fs.writeFileSync @file, '', 'utf8'
  fileExists: ->
    fs.existsSync(@file)
  loadSettings: ->
    data =  fs.readFileSync(@file, 'utf8')
    @settings = @type.loader data
    emit "#{@constructor.name}SettingsLoaded", {@file}
  update: (object) ->
    @settings = object
    @save()
  _save: ->
    data = @type.saver @settings
    fs.writeFile @file, data, 'utf8'
    emit "#{@constructor.name}SettingsSaved", {@file}
  save: ->
    @debouncedSave()


FileManager.types null,
  json:
    extension: '.json'
    loader: (data) ->
      data = if _.isEmpty data then '{}' else data
      JSON.parse data, 'utf8'
    saver: (data) ->
      data = if _.isEmpty data then {} else data
      JSON.stringify(data, null, 4)
  coffeescript:
    extension: '.coffee'
  javascript:
    extension: '.js'

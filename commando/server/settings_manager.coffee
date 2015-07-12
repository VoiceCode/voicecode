fs = Meteor.npmRequire('fs')
path = Meteor.npmRequire('path')

class @SettingsManager
  constructor: (@name) ->
    @file = path.resolve(projectRoot, "user", "#{@name}.json")
    if @needsMigration()
      @migrate()
    else
      @loadSettings()
  needsMigration: ->
    not @fileExists()
  migrate: ->
    @settings = {}
    @save()
  fileExists: ->
    fs.existsSync(@file)
  loadSettings: ->
    @settings = JSON.parse(fs.readFileSync(@file, 'utf8'))
  update: (object) ->
    @settings = object
    @save()
  save: ->
    fs.writeFileSync @file, JSON.stringify(@settings, null, 4), 'utf8'

class @EnabledCommandsManager extends SettingsManager
  # singleton
  instance = null
  constructor: ->
    if instance
      return instance
    else
      instance = super("enabled_commands")
  migrate: ->
    @settings = {}
    for key, value of Commands.mapping
      @settings[key] = !!Enables.findOne(name: key)?.enabled
    @save()
  enable: (name) ->
    @settings[name] = true
    @save()
  disable: (name) ->
    @settings[name] = false
    @save()

Meteor.methods
  "loadSettings": (name) ->
    switch name
      when "enabled_commands"
        manager = new EnabledCommandsManager()
        manager.settings

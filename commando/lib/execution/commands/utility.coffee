Commands.Utility =
  numberCaptureCommands: ->
    r = _.filter(_.keys(Commands.mapping), (key) ->
      Commands.mapping[key].grammarType is "numberCapture"
    )
    _.sortBy(r, (e) -> e).reverse()
  repeatableCommands: ->
    r = _.filter(_.keys(Commands.mapping), (key) ->
      Commands.mapping[key].grammarType is "repeatable"
    )
    _.sortBy(r, (e) -> e).reverse()
  textCaptureCommands: ->
    r = _.filter(_.keys(Commands.mapping), (key) ->
      Commands.mapping[key].grammarType is "textCapture"
    )
    _.sortBy(r, (e) -> e).reverse()
  individualCommands: ->
    r = _.filter(_.keys(Commands.mapping), (key) ->
      Commands.mapping[key].grammarType is "individual"
    )
    _.sortBy(r, (e) -> e).reverse()
  oneArgumentCommands: ->
    r = _.filter(_.keys(Commands.mapping), (key) ->
      Commands.mapping[key].grammarType is "oneArgument"
    )
    _.sortBy(r, (e) -> e).reverse()
  numberCommands: ->
    r = _.filter(_.keys(Commands.mapping), (key) ->
      _.contains (Commands.mapping[key].tags or []), "number"
    )
    _.sortBy(r, (e) -> e).reverse()
  letterCommands: ->
    r = _.filter(_.keys(Commands.mapping), (key) ->
      _.contains (Commands.mapping[key].tags or []), "letter"
    )
    _.sortBy(r, (e) -> e).reverse()
  allTags: ->
    result = []
    _.each(Commands.mapping, (command, key) ->
      _.each (command.tags or []), (tag) ->
        result.push tag
    )
    _.uniq result
  allEnabledTags: (enabled) ->
    enabled = switch enabled
      when "enabled"
        true
      when "disabled"
        false
      else
        "all"
    result = []
    _.each Commands.mapping, (command, key) ->
      if (enabled is "all") or (command.enabled is enabled)
        _.each (command.tags or []), (tag) ->
          result.push tag
    _.uniq result
  allModules: ->
    result = []
    _.each(Commands.mapping, (command, key) ->
      result.push command.module
    )
    _.uniq result
  scopedCommands: (tag) ->
    _.filter(_.keys(Commands.mapping), (key) ->
      _.contains (Commands.mapping[key].tags or []), tag
    )
  enabledCommandNames:  ->
    _.filter(_.keys(Commands.mapping), (key) ->
      Commands.mapping[key].enabled is true
    )
  scopedCommandsWithToggle: (tag, toggle) ->
    enabled = switch toggle
      when "enabled"
        true
      when "disabled"
        false
      else
        "all"
    _.filter _.keys(Commands.mapping), (key) ->
      command = Commands.mapping[key]
      (enabled is "all" or (command.enabled is enabled)) and _.contains((command.tags or []), tag)


  scopedModules: (module) ->
    _.filter(_.keys(Commands.mapping), (key) ->
      Commands.mapping[key].module is module
    )

  documentationReport: ->
    tags = Commands.Utility.allTags()
    commands = {}
    _.each tags, (tag) ->
      commands[tag] = _.map Commands.Utility.scopedCommands(tag), (key) ->
        command = Commands.mapping[key]
        {
          name: key
          kind: command.kind
          description: command.description
          grammarType: command.grammarType
          actions: command.actionDescriptionString()
        }

  addAliases: (key, aliases) ->
    Commands.mapping[key].aliases ?= []
    Commands.mapping[key].aliases.push.apply(Commands.mapping[key].aliases, aliases)

  changeName: (old, newName) ->
    Commands.mapping[newName] = Commands.mapping[old]
    delete Commands.mapping[old]

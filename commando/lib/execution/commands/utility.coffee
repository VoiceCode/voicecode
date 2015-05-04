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
      command = Commands.mapping[key]
      command.grammarType is "individual" or command.grammarType is undefined # and not command.findable?
    )
    _.sortBy(r, (e) -> e).reverse()
  findableCommands: ->
    r = _.filter(_.keys(Commands.mapping), (key) ->
      Commands.mapping[key].findable?
    )
    _.sortBy(r, (e) -> e).reverse()
  singleSearchCommands: ->
    r = _.filter(_.keys(Commands.mapping), (key) ->
      Commands.mapping[key].grammarType is "singleSearch"
    )
    _.sortBy(r, (e) -> e).reverse()
  repeaterCommands: ->
    r = _.filter(_.keys(Commands.mapping), (key) ->
      Commands.mapping[key].repeater?
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
      (enabled is "all" or (command.enabled is enabled)) and (tag is "all" or _.contains((command.tags or []), tag))


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

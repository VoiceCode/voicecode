Commands.Utility =
  sortedCommandKeys: (kind, continuous=false) ->
    if continuous
      _.sortBy(Commands.keys["#{kind}Continuous"], (e) -> e).reverse()
    else
      _.sortBy(Commands.keys[kind], (e) -> e).reverse()
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
  enabledCommandNames: ->
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

  customCommandNames: ->
    Commands.keys.custom.concat(Commands.keys.customContinuous)

  scopedModules: (module) ->
    _.filter(_.keys(Commands.mapping), (key) ->
      Commands.mapping[key].module is module
    )

  getUsedOptionLists: ->
    lists = {}

    for name in Commands.Utility.customCommandNames()
      command = new Commands.Base(name, null)
      for listName in command.listNames()
        unless listName in lists
          lists[listName] = Settings.getSpokenOptionsForList(listName)
    lists

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

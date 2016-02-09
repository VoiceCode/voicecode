module.exports =
  sortedCommandKeys: (kind) ->
    keys = _.filter Commands.keys[kind], (id) ->
      Commands.get(id)?.enabled

    _.sortBy(keys, (id) ->
      Commands.get(id)?.spoken
    ).reverse()

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

  scopedCommandsWithToggle: (tag, toggle) ->
    enabled = switch toggle
      when "enabled"
        true
      when "disabled"
        false
      else
        "all"
    if tag is "all"
      _.filter _.keys(Commands.mapping), (key) ->
        command = Commands.mapping[key]
        (enabled is "all" or (command.enabled is enabled)) and (command.tags or []).indexOf("modifiers") < 0
    else
      _.filter _.keys(Commands.mapping), (key) ->
        command = Commands.mapping[key]
        (enabled is "all" or (command.enabled is enabled)) and (tag is "all" or _.contains((command.tags or []), tag))

  customCommandNames: ->
    Commands.keys.custom

  scopedModules: (module) ->
    _.filter(_.keys(Commands.mapping), (key) ->
      Commands.mapping[key].module is module
    )

  getUsedOptionLists: (kind='spoken') ->
    lists = {}

    for name in Commands.Utility.customCommandNames()
      command = new Command(name, null)
      for listName, options of command.grammar.listsWithOptions(kind)
        if listName in lists
          unless _.isEqual options, lists[listName]
            console.error "conflicting dynamic list values from command: #{name}, list: #{listName}"
        else
          lists[listName] = options
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

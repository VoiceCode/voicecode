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
    _.each(_.keys(Commands.mapping), (key) ->
      _.each (Commands.mapping[key].tags or []), (tag) ->
        result.push tag
    )
    _.uniq result
  allModules: ->
    result = []
    _.each(_.keys(Commands.mapping), (key) ->
      result.push Commands.mapping[key].module
    )
    _.uniq result
  scopedCommands: (tag) ->
    _.filter(_.keys(Commands.mapping), (key) ->
      _.contains (Commands.mapping[key].tags or []), tag
    )
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

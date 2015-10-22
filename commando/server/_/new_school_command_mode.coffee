class @NewSchoolCommandMode
  constructor: ->
    @groups = []

  generate: (groupsInTotal = 3)->
    groupsInTotal--
    all = _.map Commands.mapping, (value, key) ->
      if value.enabled and value.isSpoken isnt false and
      value.needsDragonCommand isnt false and
      # value.kind not 'grammar' and
      value.grammarType isnt 'custom'
        spoken = value.triggerPhrase or key
        return {spoken, command: value}
      return null

    all = _.compact all
    # console.error all
    yesInput = _.filter all, ({command}) -> command.inputRequired || false
    noInput = _.reject all, ({command}) -> command.inputRequired || false
    noncontinuous = _.filter all, ({command}) -> command.continuous is false
    # console.log noncontinuous
    yesInput = _.pluck yesInput, 'spoken'
    noInput = _.pluck noInput, 'spoken'
    noncontinuous = _.pluck noncontinuous, 'spoken'
    groups = _.map [0..groupsInTotal], -> []
    # noInput = ['one two three', 'four five six', 'non con']
    # yesInput = ['input']
    # noncontinuous = ['non con']
    # console.log "noInput #{noInput}"
    # console.log "yesInput #{yesInput}"
    # console.log "noncontinuous #{noncontinuous}"
    _.each [0..groupsInTotal], (currentGroupNumber) ->
      commandsToInclude = noInput
      if currentGroupNumber is groupsInTotal
        commandsToInclude = commandsToInclude.concat yesInput
      commandsToInclude = _.unique commandsToInclude
      # console.log commandsToInclude
      _.each commandsToInclude, (fullCommandName) ->
        tokenized = fullCommandName.split ' '
        _.each [currentGroupNumber..groupsInTotal], (groupToPushTo, currentPosition) ->
          if tokenized[currentPosition]
            if fullCommandName in noncontinuous
              if tokenized[currentGroupNumber]?
                groups[currentGroupNumber].push tokenized[currentGroupNumber]
              return
            groups[groupToPushTo].push tokenized[currentPosition]
    @groups = _.map groups, (values, index) -> _.unique values
    # console.error @groups
    @

  create: ->
    variables = {}
    triggerPhrase = ''
    groupsInTotal = _.size @groups
    groupNames = ['one', 'two', 'three', 'four']
    _.each [0...groupsInTotal], (groupNumber) =>
      groupName = "group#{groupNames[groupNumber]}"
      triggerPhrase += "(#{groupName})"
      triggerPhrase += '*' if groupNumber > 0
      triggerPhrase += ' ' unless groupNumber is groupsInTotal
      variables[groupName] = _.toArray @groups[groupNumber]
    Commands.create "vc-all-with-input",
      kind : "recognition"
      grammarType : "custom"
      description : ""
      rule : triggerPhrase
      variables: variables
      tags : ["ai"]
      continuous: false
      action : (input)->

  mutate: ->
    @mutateSearchCommands()

  mutateSearchCommands: ->
    findables = {findables: Commands.keys.findables}
    _.each Commands.keys.singleSearch, (commandName) ->
      Commands.edit commandName, 'commandEdit', (command) ->
        command.grammarType = 'custom'
        command.rule = '<name> (findables)*'
        command.variables = findables
        command

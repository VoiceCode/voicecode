class @NewSchoolCommandMode
  constructor: ->
    @groups = []

  generate: (groupsInTotal = 3)->
    groupsInTotal--
    all = _.map Commands.mapping, (value, key) ->
      if value.enabled and value.isSpoken isnt false and
      value.needsDragonCommand isnt false and
      value.kind isnt 'grammar'

        spoken = value.triggerPhrase or key
        return {spoken, command: value}
      return null

    all = _.compact all
    yesInput = _.filter all, ({command}) -> command.inputRequired || false
    noInput = _.reject all, ({command}) -> command.inputRequired || false
    noncontinuous = _.filter all, ({command}) -> command.continuous is false
    # console.log noncontinuous
    yesInput = _.pluck yesInput, 'spoken'
    noInput = _.pluck noInput, 'spoken'
    noncontinuous = _.pluck noncontinuous, 'spoken'
    groups = _.map [0..groupsInTotal], -> []
    # noInput = ['one two three', 'four five six', 'non con']
    # yesInput = ['yesin put']
    # noncontinuous = ['non con']

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
    groupNames = 'acbdefg'
    variables = {}
    triggerPhrase = ''
    groupsInTotal = _.size @groups
    _.each [0...groupsInTotal], (iteration) =>
      groupName = groupNames.charAt iteration
      triggerPhrase += "(#{groupName})"
      triggerPhrase += '*' if iteration > 1
      triggerPhrase += ' ' unless iteration is groupsInTotal
      variables[groupName] =
        mapping:
          commands: @groups[iteration]
    # console.log groups
    Commands.create "commands",
      kind : "grammar" # take notice
      grammarType : "dynamic"
      description : ""
      triggerPhrase : triggerPhrase
      variables: variables
      tags : ["ai"]
      continuous: false
      action : (input) ->
        return new Pizza

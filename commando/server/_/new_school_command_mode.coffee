class @NewSchoolCommandMode
  constructor: ->
    @groups = []

  generate: (groupsInTotal = 3)->
    groupsInTotal--
    all = _.map Commands.mapping, (value, key) ->
      if value.enabled and value.isSpoken isnt false and
      value.needsDragonCommand isnt false and
      # value.kind not 'grammar' and
      value.grammarType isnt 'dynamic'
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
    groupNames = 'abcdefg'
    variables = {}
    triggerPhrase = ''
    groupsInTotal = _.size @groups
    _.each [0...groupsInTotal], (groupNumber) =>
      groupName = groupNames.charAt groupNumber
      triggerPhrase += "(#{groupName})"
      triggerPhrase += '*' if groupNumber > 0
      triggerPhrase += ' ' unless groupNumber is groupsInTotal
      variables[groupName] = _.toArray @groups[groupNumber]
    # console.log groups
    Commands.create "vc-all-with-input",
      kind : "grammar" # take notice
      grammarType : "dynamic"
      description : ""
      triggerPhrase : triggerPhrase
      variables: variables
      tags : ["ai"]
      continuous: false
      action : (input)->

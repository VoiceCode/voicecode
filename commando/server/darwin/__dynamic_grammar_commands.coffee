class @DynamicGrammar
  constructor: ->



  generate: ->
    all = _.map Commands.mapping, (value, key) ->
      if value.enabled and value.isSpoken isnt false and
      value.needsDragonCommand isnt false and
      value.grammarType isnt 'dynamic'

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
    groupsInTotal = 3
    groups = {}
    # noInput = [{spoken: 'one two three'}, {spoken: 'four five six'}, {spoken: 'non con'}]
    # yesInput = [{spoken: 'yesinput'}]
    # noncontinuous = ['non con']


    _.each [1..groupsInTotal], (groupNumber) ->
      groups[groupNumber] ?= []

    _.each [1..groupsInTotal], (currentGroupNumber) ->
      commandsToInclude = noInput
      if currentGroupNumber is groupsInTotal
        commandsToInclude = commandsToInclude.concat yesInput
      commandsToInclude = _.unique commandsToInclude, 'spoken'
      console.log commandsToInclude
      _.each commandsToInclude, (fullCommandName) ->
        tokenized = fullCommandName.split ' '
        _.each [currentGroupNumber..groupsInTotal], (groupToPushTo, currentPosition) ->
          if tokenized[currentPosition]
            if fullCommandName in noncontinuous
              if tokenized[currentGroupNumber - 1]?
                groups[currentGroupNumber].push tokenized[currentGroupNumber - 1]
              return
            groups[groupToPushTo].push tokenized[currentPosition]
    console.error _.map groups, (values, index) -> _.unique values
    #
    # # console.log groups
    # Commands.create "commands",
    #   kind : "action"
    #   grammarType : "dynamic"
    #   description : ""
    #   triggerPhrase : '(first)'
    #   variables: {
    #     'first': {
    #       mapping:
    #         commands: groups[1]
    #     }
    #     # 'second': {
    #     #   mapping:
    #     #     commands: groups[2]
    #     # }
    #     # 'third': {
    #     #   mapping:
    #     #     commands: groups[3]
    #     # }
    #   }
    #   tags : ["ai"]
    #   continuous: false
    #   action : (input) ->
    #     return new Pizza

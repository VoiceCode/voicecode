Template.Vocab.helpers
  # vocabGroups: ->
  #   keys = _.keys(Commands.mapping)
  #   limit = (keys.length / 4)
  #   _.map([0..limit], (index) ->
  #     console.log index
  #     keys.splice(0, 4).join(", ")
  #   )
  vocabList: ->
    if enablesSubscription.ready()
      commands = []
      _.each Commands.mapping, (value, key) ->
        if value.enabled and value.grammarType? and (value.isSpoken isnt false)
          spoken = value.triggerPhrase or key
          commands.push spoken
      _.sample(commands, commands.length).join(" ")
  repeatableList: ->
    if enablesSubscription.ready()
      commands = []
      me = @toString()
      _.each Commands.mapping, (value, key) ->
        if value.enabled and (value.grammarType is "individual" or value.grammarType is undefined) and (value.isSpoken isnt false)
          spoken = value.triggerPhrase or key
          commands.push spoken
      _.map(['soup', 'trace', 'quarr', 'fypes'], (item) ->
        _.sample(commands, commands.length).join(" #{item} ")
      ).join(" ")

  keeperList: ->
    if enablesSubscription.ready()
      commands = []
      _.each Commands.mapping, (value, key) ->
        if value.enabled and value.grammarType? and (value.isSpoken isnt false)
          spoken = value.triggerPhrase or key
          commands.push spoken
      _.sample(commands, commands.length).join(" keeper ")

  phonetics: ->
    # results = []
    # for letter in phoneticLetters
      
    #   for second in phoneticLetters

    # websites = _.keys Settings.websites
    # applications = _.keys Settings.applications
    # keys = commands.concat(websites).concat(applications)
    # _.sample(keys, keys.length).join(" ")

Template.Vocab.events
  "click .selectable": (event, template) ->
    target = event.currentTarget
    if document.body.createTextRange
      range = document.body.createTextRange()
      range.moveToElementText target
      range.select()
    else if window.getSelection
      selection = window.getSelection()
      range = document.createRange()
      range.selectNodeContents target
      selection.removeAllRanges()
      selection.addRange range


Template.Vocab.helpers
  vocabGroups: ->
    keys = _.keys(Commands.mapping)
    limit = (keys.length / 4)
    _.map([0..limit], (index) ->
      console.log index
      keys.splice(0, 4).join(", ")
    )
  vocabList: ->
    commands = _.keys(Commands.mapping)
    websites = _.keys CommandoSettings.websites
    applications = _.keys CommandoSettings.applications
    keys = commands.concat(websites).concat(applications)
    _.sample(keys, keys.length).join(" ")

Template.Vocab.events

Meteor.methods
  parseGeneratorString: ->
    ParseGenerator.string

  execute: (phrase) ->
    chain = new Commands.Chain(phrase)
    results = chain.execute(true)

  findDragonCommand: (name) ->
    command = new Commands.Base(name, null)
    dragonName = command.generateDragonCommandName()
    script = """
    tell application "Dragon Dictate"
      reveal command "#{dragonName}" of group "Global"
    end tell
    """
    f = """osascript <<EOD
    #{script}
    EOD
    """
    Shell.exec f, async: true
    true

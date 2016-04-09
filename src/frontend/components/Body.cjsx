React = require 'react'
Command = require '../components/Command.cjsx'

getFormattedCommands = ->
  commands = remote.getGlobal('Commands').mapping
  commands = _.map commands, (command) ->
    command = _.pick command, [
      'id', 'spoken', 'description', 'packageId', 'enabled'
    ]
    command
  commands = _.groupBy commands, 'packageId'


module.exports = React.createClass
  displayName: 'CommandsView'
  updateCommands: ->
    @setState _.extend @state, commands: getFormattedCommands()
  componentDidMount: ->
    # Events.on 'commandEnabled', (command) => @updateCommands()
    # Events.on 'commandDisabled', (command) => @updateCommands()
  getInitialState: ->
    commands: getFormattedCommands()
  renderCommands: (commands) ->
    _.map commands, (c, index) =>
      <Command key={"#{c.id}-command"} command={c} />
  render: ->
    ''

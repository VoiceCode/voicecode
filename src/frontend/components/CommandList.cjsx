React = require 'react'
Command = require '../components/Command.cjsx'

CommandList = class CommandList extends React.Component
  render: ->
    <div>
    {
      output = []
      @props.commands.forEach (command) ->
        output.push <Command key={ command.id } command={ command } />
      output
    }
    </div>

module.exports = CommandList

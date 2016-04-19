React = require 'react'
Command = require '../components/Command.cjsx'
{connect} = require 'react-redux'

CommandList = class CommandList extends React.Component
  render: ->
    <div className="ui relaxed divided list"> {
      _.map @props.commands, (command) ->
        <Command key={ command.id } {...command} />
      }
    </div>

module.exports = CommandList

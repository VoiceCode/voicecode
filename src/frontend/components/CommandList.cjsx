React = require 'react'
Command = require '../components/Command.cjsx'
{List} = require 'material-ui'
{connect} = require 'react-redux'

CommandList = class CommandList extends React.Component
  render: ->
    <List> {
      _.map @props.commands, (command) ->
        <Command key={ command.id } command={ command } />
      }
    </List>

module.exports = CommandList

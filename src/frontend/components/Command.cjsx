React = require 'react'
{ListItem, Toggle} = require 'material-ui'
Command = class Command extends React.Component
  render: ->
    {id, spoken, enabled, packageId} = @props.command
    <ListItem
      primaryText={ spoken }
      secondaryText={ id.replace "#{packageId}:", '' }
      leftCheckbox={
        <Toggle
          defaultToggled={ enabled }
        /> }
      >
    </ListItem>

module.exports = Command

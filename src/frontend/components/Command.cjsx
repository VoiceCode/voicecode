React = require 'react'
ListItem = require 'material-ui/lib/lists/list-item'
Toggle = require 'material-ui/lib/toggle'
IconButton = require 'material-ui/lib/icon-button'

module.exports = React.createClass
    displayName: 'Command'
    onToggle: (event, toggled) -> emit (if toggled then 'enableCommand' else 'disableCommand'), @props.command.id
    render: ->
      <ListItem primaryText={ @props.command.spoken } secondaryText={
          <p>
            { @props.command.description }
          </p>
        # } secondaryTextLines={ if @props.command.description?.length >= 300 then 2 else 1 }
        } secondaryTextLines={ 1 }
        leftCheckbox={
          <Toggle defaultToggled={ @props.command.enabled } onToggle={ @onToggle }/>
        } rightIconButton={
          <IconButton iconClassName="material-icons" tooltipPosition="bottom-center" tooltip="Edit">edit</IconButton>
        }
        />

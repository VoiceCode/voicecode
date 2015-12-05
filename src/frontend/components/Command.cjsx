React = require 'react'
ListItem = require 'material-ui/lib/lists/list-item'
Toggle = require 'material-ui/lib/toggle'

module.exports = React.createClass
    displayName: 'Command'
    render: ->
      <ListItem primaryText={ @props.command.spoken } secondaryText={
          <p>
            <strong>{ @props.command.id }</strong><br/>
            { @props.command.description }
          </p>
        } secondaryTextLines={2}
        rightToggle={
          <Toggle defaultToggled={ @props.command.enabled } />
        }
        />

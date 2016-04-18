React = require 'react'
{ListItem, Toggle} = require 'material-ui'
{ connect } = require 'react-redux'
{enableCommand, disableCommand} = require('../ducks/command').actionCreators
mapDispatchToProps = {
  enableCommand, disableCommand
}
class Command extends React.Component
  render: ->
    {testicle, enableCommand} = @props
    {id, spoken, enabled, packageId} = @props.command
    <ListItem
      primaryText={ spoken }
      secondaryText={ id.replace "#{packageId}:", '' }
      leftCheckbox={
        <Toggle
          defaultToggled={ enabled }
          onToggle={ enableCommand }
        /> }
      >
    </ListItem>

module.exports = connect(null, mapDispatchToProps)(Command)

React = require 'react'
{connect} = require 'react-redux'
Command = require '../components/Command.cjsx'
{toggleCommand} = require('../ducks/command').actionCreators
mapDispatchToProps = {
  toggleCommand
}
CommandList = class CommandList extends React.Component
  shouldComponentUpdate: (nextProps, nextState) ->
    @props.commands isnt nextProps.commands
  toggleCommands: ->
    {commands, toggleCommand} = @props
    commands = commands.toJS()
    [enabled, disabled] = _.partition commands, ['enabled', true]
    [enabledCount, disabledCount] = _.map [enabled, disabled], _.size
    direction = if enabledCount >= disabledCount
      true
    else
      false
    if (enabledCount or disabledCount) is commands.length
      direction = !direction
    _.each commands, (command) ->
      toggleCommand command.id, direction

  render: ->
    {commands} = @props
    return null unless commands.size
    <div className="ui segment">
      <div className="ui top left attached label allCommandToggle"
           onClick={ @toggleCommands.bind(@) }
           title='toggle all'
      >
        <i className="toggle on icon"></i>
        { commands.size }
        { if commands.size is 1 then ' command' else ' commands' }
      </div>
      { if commands.size
          <div className="ui relaxed divided list">
          {
            commands.map (command) ->
              <Command key={ command.id } commandId={ command.id } />
          }
          </div>
      }
    </div>


module.exports = connect(null, mapDispatchToProps) CommandList

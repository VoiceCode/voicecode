React = require 'react'
Command = require '../components/Command.cjsx'


CommandList = class CommandList extends React.Component
  shouldComponentUpdate: (nextProps, nextState) ->
    @props.commands isnt nextProps.commands

  render: ->
    console.info "rendering command list"
    {commands} = @props
    <div className="ui segment">
      <div className="ui top left attached label">
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


module.exports = CommandList

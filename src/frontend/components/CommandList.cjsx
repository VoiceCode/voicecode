React = require 'react'
Command = require '../components/Command.cjsx'
{connect} = require 'react-redux'
{commandsForPackage} = require '../selectors'
makeMapStateToProps = (state, props)->
    commands: commandsForPackage state, props


CommandList = class CommandList extends React.Component
  shouldComponentUpdate: (nextProps, nextState) ->
    @props.commands isnt nextProps.commands

  render: ->
    console.info "rendering command list: #{@props.packageId}"
    {commands} = @props
    <div className="ui segment">
      <div className="ui top left attached label">
        { commands.size }
        { if commands.size is 1 then ' command' else ' commands' }
      </div>
      { if commands.size
          <div className="ui relaxed divided list">
          {
            commands.map (command, index) ->
              <Command key={ index } commandId={ command } />
          }
          </div>
      }
    </div>


module.exports = connect(makeMapStateToProps)(CommandList)

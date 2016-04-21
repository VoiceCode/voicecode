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
    <div className="ui relaxed divided list">
    {
      @props.commands.map (command, index) ->
        <Command key={ index } commandId={ command } />
    }
    </div>

module.exports = connect(makeMapStateToProps)(CommandList)

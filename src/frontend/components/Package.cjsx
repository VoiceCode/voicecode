React = require 'react'
CommandList = require './CommandList.cjsx'
immutable = require 'immutable'

Package = class Package extends React.Component
  constructor: ->
    super
  # state: {commands: new immutable.Map({})}

  # shouldComponentUpdate: (nextProps, nextState) ->
    # return true if nextProps.package.get('commands') isnt @props.package.get('commands')
    # return

  # componentWillReceiveProps: (nextProps) ->
  #   commands = @state.commands
  #   console.error 'WILL RECEIVE PROPS', nextProps
  #   window.next = nextProps
  #   nextProps.package.get('commands').forEach (commandId) ->
  #     command = store.getState().commands.get commandId
  #     commands = commands.set commandId, command
  #
  #   @setState {commands}

  # componentWillMount: ->
  #   console.error 'COMPONENT WILL MOUNT'
  #
  # componentWillReceiveProps: (nextProps) ->
  #   console.error 'COMPONENT WILL RECEIVE PROPS'

  render: ->
    console.error "RENDERING PACKAGE: #{@props.package.name}"
    <div>
      <hr />
      <h1>{ @props.package.name }</h1>
      <p>{ @props.package.description }</p>
      <CommandList commands={ @props.package.commands } />
    </div>

module.exports = Package

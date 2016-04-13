React = require 'react'
{ connect } = require 'react-redux'

Command = class Command extends React.Component
  constructor: ->
    super
  # shouldComponentUpdate: (nextProps, nextState) ->
  #   shouldUpdate = @props.command isnt nextProps.command
  #   console.warn 'SHOULD UPDATE', shouldUpdate
  #   shouldUpdate

  # componentWillReceiveProps: (nextProps) ->
  #   console.log 'WILL RECEIVE PROPS', nextProps

  # componentDidUpdate: (prevProps, prevState) ->
  #   console.log 'COMPONENT DID UPDATE', @

  render: ->
    console.log 'RENDERING', this
    <div>
      <input type="checkbox" onClick={ @onClick } />
      <h1>id: { @props.command.id}</h1>
      <p>spoken: { @props.command.spoken }</p>
      <p>enabled: { @props.command.enabled.toString() }</p>
    </div>

module.exports = Command

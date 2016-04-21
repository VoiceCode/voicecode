React = require 'react'
{ connect } = require 'react-redux'
{toggleCommand} = require('../ducks/command').actionCreators
{commandSelector} = require '../selectors'

mapStateToProps = (state, props) ->
  command: commandSelector state, props

mapDispatchToProps = {
  toggleCommand
}
class Command extends React.Component
  shouldComponentUpdate: (nextProps, nextState) ->
    @props.command isnt nextProps.command

  render: ->
    {toggleCommand} = @props
    {id, spoken, enabled, packageId, implementations} = @props.command.toJS()
    console.warn "rendering command: #{id}"
    <div className="item">
      <div className="ui fitted checkbox">
        <input
        type="checkbox"
        checked={ enabled }
        onChange={ (event) ->
          toggleCommand id, event.target.checked }/>
        <label></label>
      </div>

      <div className="content">
        <div className="header">{ spoken }</div>
        <div className="meta">{ id }</div>
        <a className="ui mini gray label"> hello</a>
      </div>
    </div>

module.exports = connect(mapStateToProps, mapDispatchToProps)(Command)

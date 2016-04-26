React = require 'react'
{ connect } = require 'react-redux'
{toggleCommand} = require('../ducks/command').actionCreators
{commandSelector, implementationsForCommand} = require '../selectors'
classNames = require 'classnames'
mapStateToProps = (state, props) ->
  command: commandSelector state, props
  implementations: implementationsForCommand state, props
mapDispatchToProps = {
  toggleCommand
}
class Command extends React.Component
  shouldComponentUpdate: (nextProps, nextState) ->
    @props.command isnt nextProps.command

  render: ->
    {toggleCommand, implementations} = @props
    {id, spoken, enabled, packageId, description, locked} = @props.command.toJS()
    console.warn "rendering command: #{id}"
    iconClasses = classNames
      'large middle aligned icon': true
      'toggle on': enabled
      'toggle off': !enabled
      'grey': locked
    <div className="item">
      <i className={iconClasses}
         onClick={
           if not locked
             (event) ->
               toggleCommand id, !enabled
           }
      ></i>
      <div className="content">
        <div className="header">
        {
          if not spoken
              <i className='tiny grey mute icon'></i>
          else
            spoken
        }
        </div>
        <div className="meta">{ id }</div>
        <div className='content'>{ description }</div>
        <div className='extra'>
          {
            implementations.map (imp) ->
              <a className="ui mini gray label">{ imp }</a>
          }
        </div>
      </div>
    </div>

module.exports = connect(mapStateToProps, mapDispatchToProps)(Command)

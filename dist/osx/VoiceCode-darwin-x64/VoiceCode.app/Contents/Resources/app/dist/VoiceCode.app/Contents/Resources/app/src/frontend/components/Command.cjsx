React = require 'react'
{connect} = require 'react-redux'
classNames = require 'classnames'
{toggleCommand} = require('../ducks/command').actionCreators
{setPackageFilter} = require('../ducks/package_filter').actionCreators
{commandSelector, implementationsForCommand} = require '../selectors'

mapStateToProps = (state, props) ->
  command: commandSelector state, props
  implementations: implementationsForCommand state, props
mapDispatchToProps = {
  toggleCommand,
  setPackageFilter
}
class Command extends React.Component
  shouldComponentUpdate: (nextProps, nextState) ->
    @props.command isnt nextProps.command

  render: ->
    console.log 'rendering command'
    {toggleCommand, implementations, setPackageFilter} = @props
    {id, spoken, enabled, packageId,
    description, locked, rule, tags} = @props.command.toJS()
    iconClasses = classNames
      'large middle aligned icon': true
      'toggle on': enabled
      'toggle off': !enabled
      'grey': locked
    <div className="item">
      <i className={iconClasses}
         onClick={
           if not locked
             toggleCommand.bind @, id, !enabled
           }
      ></i>
      <div className="content">
        <div className="header">
        {
          if not spoken? and not rule?
              <i className='tiny grey mute icon'></i>
          else
            if rule? and spoken?
              rule.replace('<spoken>', spoken)
            else
              rule or spoken
        }
        </div>
        <div className="meta">{ id }</div>
        <div className='content'>{ description }</div>
        <div className='extra'>
          {
            tags.map (tag) ->
              <a key={ tag }
                 className="ui mini tag label"
                 onClick={ setPackageFilter.bind null, {scope: 'tags', query: tag} }
              >{ tag }</a>
          }
        </div>
      </div>
    </div>

module.exports = connect(mapStateToProps, mapDispatchToProps)(Command)

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
  # componentDidMount: ->
  #   $('.rule.dropdown').dropdown({
  #     transition: 'fade up',
  #     on: 'hover'
  #   })
  render: ->
    {toggleCommand, implementations, setPackageFilter} = @props
    {id, spoken, enabled, packageId,
    description, locked, rule, tags} = @props.command.toJS()
    iconClasses = classNames
      'large middle aligned icon': true
      'toggle on': enabled
      'toggle off': !enabled
      'grey': locked
    <div className="item command">
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
              <i className='grey mute icon'></i>
          else
              if rule? and spoken?
                rule.replace('<spoken>', spoken)
              else
                if rule?
                  # <div className='rule ui inline pointing dropdown'>
                  #   { rule } <i className='dropdown icon'></i>
                  #   <div className='menu'>
                  #     <div className='item'>test</div>
                  #     <div className='item'>test 2</div>
                  #   </div>
                  # </div>
                  rule
                else
                  <div className='spoken'>
                    { spoken }
                  </div>

        }
        </div>
        <div className="meta">{ id }</div>
        <div className='content description'>{ description }</div>
        {
          if tags?
            <div className='extra'>
              {
                tags.map (tag) ->
                  <a key={ tag }
                     className="ui mini tag label"
                     onClick={ setPackageFilter.bind null, {scope: 'tags', query: tag} }
                  >{ tag }</a>
              }
            </div>
        }
        </div>
    </div>

module.exports = connect(mapStateToProps, mapDispatchToProps)(Command)

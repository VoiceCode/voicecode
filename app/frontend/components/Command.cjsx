React = require 'react'
{connect} = require 'react-redux'
classNames = require 'classnames'
{toggleCommand} = require('../ducks/command').actionCreators
{setCommandFilter} = require('../ducks/command_filter').actionCreators
{
  commandSelector,
  makeImplementationsForCommand,
  grammarForCommandSelector
} = require '../selectors'

mapStateToProps = (state, props) ->
  implementationsForCommand = makeImplementationsForCommand()

  grammarForCommand: grammarForCommandSelector state, props
  command: commandSelector state, props
  implementations: implementationsForCommand state, props
mapDispatchToProps = {
  toggleCommand,
  setCommandFilter
}
class Command extends React.Component
  shouldComponentUpdate: (nextProps, nextState) ->
    @props.command isnt nextProps.command
  # componentDidMount: ->
  #   $('.rule').dropdown({
  #     transition: 'fade up',
  #     on: 'hover'
  #   })
  render: ->
    {toggleCommand, setCommandFilter, grammarForCommand} = @props
    {id, spoken, enabled, packageId,
    description, locked, rule, tags} = @props.command.toJS()
    iconClasses = classNames
      'large middle aligned icon': true
      'toggle on': enabled
      'toggle off': !enabled
      'grey': locked
    description = description.split('␣').map (item, index) ->
      if index > 0
        [<span className='space'>␣</span>, item]
      else
        item
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
            if rule?
              @renderRule rule, spoken
            else
              <div className='spoken'>
                { spoken }
              </div>

        }
        </div>
        <div className="meta">
          { id }
          {' '}
          { @implementations() }
        </div>
        <div className='content description'>{ description }</div>
        {
          if tags?
            <div className='extra'>
              {
                tags.map (tag) ->
                  <a key={ "#{id}-#{tag}" }
                     className="ui mini tag label"
                     onClick={ setCommandFilter.bind null, {scope: 'tags', query: tag} }
                  >{ tag }</a>
              }
            </div>
        }
        </div>
    </div>
  renderRule: ->
    {grammarForCommand} = @props
    rule = @props.command.get 'rule'
    spoken = @props.command.get 'spoken'
    enabled = @props.command.get 'enabled'
    count = 0
    items = {}
    rule = rule.replace /\((.*?)\)\?*/g, (part, name) ->
      optional = part.indexOf(')?') isnt -1
      if part.indexOf('/') isnt -1
        name = _.camelCase name.replace('/', ' ')
      items[++count] = {name, optional}
      "_#{count}"
    if spoken?
      rule = rule.replace '<spoken>', _.toUpper spoken
    inner = _.map rule.split(' '), (part) ->
      if part[0] is '_'
        index = part.replace '_', ''
        dropDownClasses = classNames
          dropdown: enabled
          icon: enabled
        grammarListClasses = classNames
          horizontal: true
          "ui small label simple": true
          dropdown: enabled
          blue: !items[index].optional
          gray: items[index].optional
        <div className={ grammarListClasses }>
          { items[index].name }
          <i className={ dropDownClasses }> </i>
            <div className='menu'>
            {
              if enabled
                _.map grammarForCommand.get(items[index].name), (i) ->
                  <div className='item'>{ i }</div>
              else
                null
            }
            </div>
        </div>
      else
        _.toUpper part + " "
    <div className='rule ui '>
      { inner }
    </div>
  implementations: ->
    {implementations, command} = @props
    packageId = command.get 'packageId'
    commandId = command.get 'id'
    # implementations.filter((i) -> i.packageId isnt packageId)
    implementations.map (i) ->
      siblings = i.packageId is packageId
      implementationClasses = classNames
        implementation: true
        horizontal: true
        blue: not siblings
        gray: siblings
        label: true
        small: true
        ui: true
      <div key={ "#{i.id}#{i.packageId}#{i.scope}" } className={ implementationClasses }
           title={ "#{i.packageId} package, #{i.scope} scope" } >
      { if siblings then "#{i.packageId }@#{ i.scope }" else "@#{ i.scope }" }
      </div>


module.exports = connect(mapStateToProps, mapDispatchToProps)(Command)

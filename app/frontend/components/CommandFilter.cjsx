React = require 'react'
{connect} = require 'react-redux'
classNames = require 'classnames'
{setCommandFilter} = require('../ducks/command_filter').actionCreators
{commandFilterSelector} = require '../selectors'
require('semantic-ui-css/components/transition.js')
require('semantic-ui-css/components/dropdown.js')
mapDispatchToProps = {setCommandFilter}
mapStateToProps = (state, props) ->
  filter: commandFilterSelector state

class CommandFilter extends React.Component
  shouldComponentUpdate: (nextProps, nextState) ->
    @props.filter isnt nextProps.filter

  componentDidMount: ->
    if @props.filter.get('query') isnt ''
      @refs.queryInput.focus()

    $('.dropdown').dropdown({
      transition: 'fade up'
      onChange: (value, text, $selectedItem) =>
        @props.setCommandFilter scope: value
    })


  componentWillReceiveProps: (nextProps)->
    next = nextProps.filter.get('query')
    current = @refs.queryInput.value
    @refs.queryInput.value = next unless current is next
    if nextProps.filter.get('focused')
      @refs.queryInput.focus()


  onChange: _.debounce(((event) ->
    @props.setCommandFilter query: event.target.value
    ), 500)

  iconsFor: (scope, icon = true) ->
    current = @props.filter.get 'scope'
    scope ?= current
    if not icon
      return "item" + (if scope is current then ' selected active' else '')

    classNames
      'icon': true
      'tag': scope is 'tags'
      'cube': scope is 'packages'
      'announcement': scope is 'commands'
      'file text outline': scope is 'descriptions'

  render: ->
    {setCommandFilter, filter} = @props
    <div className="ui fixed secondary pointing page menu">
      {
        ['all', 'enabled', 'disabled'].map (state) =>
          <a key={ state }
            className={ classNames(
              'item': true,
              'active': filter.get('state') is state) }
            onClick={ setCommandFilter.bind @, {state} }
          >
          <i className={ classNames(
            'icon': true,
            'grey': filter.get('state') isnt state
            'black': filter.get('state') is state
            'circle': state is 'all'
            'plus circle': state is 'enabled'
            'minus circle': state is 'disabled'
          ) }></i>
          </a>
      }

      <div className="right menu">
        <div className="item">
          <div className='ui left labeled small input commandFilter'>
            <div className='ui dropdown label'>
              <div className='text'>
                <i className={ @iconsFor() }></i>
              </div>
              <i className='dropdown icon'></i>
              <div className='menu'>
                {
                  ['tags', 'packages', 'commands', 'descriptions'].map (scope) =>
                    <div key={ scope } className={ @iconsFor scope, false } data-value={ scope }>
                      <i className={ @iconsFor scope }></i>
                    </div>
                }
              </div>
            </div>
            <input
              type="text"
              ref="queryInput"
              placeholder="Search #{filter.get('scope')}"
              onBlur={ (event) => setCommandFilter {focused: false} }
              onFocus={ (event) => setCommandFilter {focused: true} }
              onChange={
                (event) =>
                  event.persist()
                  @onChange.bind(@) event
              }
            ></input>
          </div>
        </div>
      </div>
    </div>

module.exports = connect(mapStateToProps, mapDispatchToProps)(CommandFilter)

React = require 'react'
{connect} = require 'react-redux'
classNames = require 'classnames'
{setPackageFilter} = require('../ducks/package_filter').actionCreators
{packageFilterSelector} = require '../selectors'
require('semantic-ui-css/components/transition.js')
require('semantic-ui-css/components/dropdown.js')
mapDispatchToProps = {setPackageFilter}
mapStateToProps = (state, props) ->
  filter: packageFilterSelector state

class PackageFilter extends React.Component
  shouldComponentUpdate: (nextProps, nextState) ->
    @props.filter isnt nextProps.filter

  componentDidMount: ->
    $('.dropdown').dropdown({
      transition: 'fade up'
      onChange: (value, text, $selectedItem) =>
        @props.setPackageFilter scope: value
    })

  componentWillReceiveProps: (nextProps)->
    if nextProps.filter.get('focused')
      @refs.queryInput.focus()
    @refs.queryInput.value = nextProps.filter.get('query')

  onChange: _.debounce(((event) ->
    @props.setPackageFilter query: event.target.value
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
    {setPackageFilter, filter} = @props
    <div className="ui fixed secondary pointing page menu">
      {
        ['all', 'enabled', 'disabled'].map (state) =>
          <a key={ state }
            className={ classNames(
              'item': true,
              'active': filter.get('state') is state) }
            onClick={ setPackageFilter.bind @, {state} }
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
          <div className='ui left labeled small input packageFilter'>
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

module.exports = connect(mapStateToProps, mapDispatchToProps)(PackageFilter)

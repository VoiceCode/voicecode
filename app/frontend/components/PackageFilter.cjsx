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
    if @props.filter.get('query') isnt ''
      @refs.queryInput.focus()

  componentWillReceiveProps: (nextProps)->
    next = nextProps.filter.get('query')
    current = @refs.queryInput.value
    @refs.queryInput.value = next unless current is next
    if nextProps.filter.get('focused')
      @refs.queryInput.focus()


  onChange: _.debounce(((event) ->
    @props.setPackageFilter query: event.target.value
    ), 500)

  render: ->
    {setPackageFilter, filter} = @props
    <div className="ui fixed secondary pointing page menu">
      {
        _.map {
          all: 'all',
          installed: 'enabled',
          'not installed': 'disabled'
          'updatable': 'updatable'
          }, (state, key) =>
            <a key={ state }
              className={ classNames(
                'item': true,
                'active': filter.get('state') is state) }
              onClick={ setPackageFilter.bind @, {state} }
              title={ "show #{key}" }
            >
            <i className={ classNames(
              'icon': true,
              'grey': filter.get('state') isnt state
              'black': filter.get('state') is state
              'circle': state is 'all'
              'plus circle': state is 'enabled'
              'minus circle': state is 'disabled'
              'arrow circle up': state is 'updatable'
            ) }></i>
            { ' ' + _.startCase(key)}
            </a>
      }

      <div className="right menu">
        <div className="item">
          <div className='ui left labeled small input packageFilter'>
            <div className='ui label'>
              <div className='text'>
                <i className='cube icon'></i>
              </div>
            </div>
            <input
              type="text"
              ref="queryInput"
              placeholder="Search #{filter.get('scope')}"
              onBlur={ (event) => setPackageFilter {focused: false} }
              onFocus={ (event) => setPackageFilter {focused: true} }
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

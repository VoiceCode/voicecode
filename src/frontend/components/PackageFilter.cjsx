
React = require 'react'
{connect} = require 'react-redux'
{setPackageFilter} = require('../ducks/package_filter').actionCreators
{packageFilterSelector} = require '../selectors'
mapDispatchToProps = {
  setPackageFilter
}
mapStateToProps = (state, props) ->
  filter: packageFilterSelector state

class PackageFilter extends React.Component
  shouldComponentUpdate: (nextProps, nextState) ->
    false

  componentWillReceiveProps: (nextProps)->
    if nextProps.filter.get('focused')
      @refs.queryInput.focus()
    @refs.queryInput.value = nextProps.filter.get('query')

  onChange: _.debounce(((event) ->
    @props.setPackageFilter query: event.target.value
    ), 500)

  render: ->
    <div className="ui transparent inverted icon input">
      <i className="search icon"></i>
      <input
        type="text"
        ref="queryInput"
        placeholder="Search"
        onChange={
          (event) =>
            event.persist()
            @onChange.bind(@) event
        }
      ></input>
    </div>
module.exports = connect(mapStateToProps, mapDispatchToProps)(PackageFilter)

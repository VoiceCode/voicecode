React = require 'react'
Package = require '../components/Package'

{connect} = require 'react-redux'
{filteredPackagesSelector} = require '../selectors'
stateToProps = (state, props) ->
  packages: filteredPackagesSelector state, props

class PackageList extends React.Component
  shouldComponentUpdate: (nextProps, nextState) ->
    @props.packages isnt nextProps.packages
  render: ->
    {packages, viewMode} = @props
    <div className="">
    {
      packages.map (pack) ->
        <Package key={ pack.get('name') } packageId={ pack.get('name')} viewMode={ viewMode }/>
    }
    </div>

module.exports = connect(stateToProps)(PackageList)

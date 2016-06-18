React = require 'react'
Package = require '../components/Package'

{connect} = require 'react-redux'
{filteredPackagesSelector} = require '../selectors'
stateToProps = (state) ->
  packages: filteredPackagesSelector state

class PackageList extends React.Component
  shouldComponentUpdate: (nextProps, nextState) ->
    @props.packages isnt nextProps.packages
  render: ->
    console.log 'rendering package list'
    {packages} = @props
    <div className="">
    {
      packages.map (pack) ->
        <Package key={ pack.get('name') } packageId={ pack.get('name')}/>
    }
    </div>

module.exports = connect(stateToProps)(PackageList)

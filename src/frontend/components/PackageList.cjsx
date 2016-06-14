React = require 'react'
Package = require '../components/Package'

{connect} = require 'react-redux'
{filteredPackagesSelector} = require '../selectors'
stateToProps = (state) ->
  packages: filteredPackagesSelector state

class PackageList extends React.Component

  render: ->
    
    {packages} = @props
    <div className="">
    {
      packages.map (pack) ->
        <Package key={ pack.get('name') } pack={ pack } />
    }
    </div>

module.exports = connect(stateToProps)(PackageList)

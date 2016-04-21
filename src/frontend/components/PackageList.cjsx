React = require 'react'
Package = require '../components/Package'

{ connect } = require 'react-redux'
{ packagesSelector } = require '../selectors'
stateToProps = (state) ->
  return {
    packages: packagesSelector state
}


class PackageList extends React.Component

  render: ->
    console.info "rendering package list"
    {packages} = @props
    <div className="ui items">
    {
      packages.map (pack, index) ->
        <Package key={ index } pack={ pack } />
    }
    </div>

module.exports = connect(stateToProps)(PackageList)

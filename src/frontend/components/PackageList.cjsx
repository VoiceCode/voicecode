React = require 'react'
Package = require '../components/Package'

{ connect } = require 'react-redux'

stateToProps = (state) ->
  { packages, commands } = require '../selectors'
  return {
    packages: packages state
}


class PackageList extends React.Component
  render: ->
    {packages} = @props
    <div className="ui items">
    {
      _.map packages, (pack) ->
        <Package key={ pack.name } {...pack} />
    }
    </div>

module.exports = connect(stateToProps)(PackageList)

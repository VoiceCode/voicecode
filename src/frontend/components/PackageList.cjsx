React = require 'react'
Package = require '../components/Package'
{Paper} = require 'material-ui'

{ connect } = require 'react-redux'

stateToProps = (state) ->
  { packages, commands } = require '../selectors'
  return {
    packages: packages state
    commands: commands state
}


class PackageList extends React.Component
  render: ->
    {packages} = @props
    <Paper>
    {
      _.map packages, (pack) ->
        <Package key={ pack.name } {...pack} />
    }
    </Paper>

module.exports = connect(stateToProps)(PackageList)

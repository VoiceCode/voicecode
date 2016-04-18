React = require 'react'
Package = require '../components/Package'
{Paper} = require 'material-ui'
class PackageList extends React.Component
  render: ->
    <Paper>
    {
      output = []
      @props.packages.forEach (pack) ->
        output.push <Package key={ pack.name } package={ pack } />
      output
    }
    </Paper>

module.exports = PackageList

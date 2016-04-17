React = require 'react'
Package = require '../components/Package'

class PackageList extends React.Component
  render: ->
    console.error 'RENDERING PACKAGE LIST'
    <div>
    <h1>the this even work?</h1>
    {
      output = []
      @props.packages.forEach (pack) ->
        output.push <Package key={ pack.name } package={ pack } />
      output
    }
    </div>

module.exports = PackageList

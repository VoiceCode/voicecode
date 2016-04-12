React = require 'react'
{ bindActionCreators } = require 'redux'
{ connect } = require 'react-redux'
Package = require '../components/Package.cjsx'

PackageList = class PackageList extends React.Component
  constructor: ->
    # console.log @, arguments
  render: ->
    console.error 'RENDERING PACKAGE LIST'
    <div>
    {
      output = []
      @props.packages.forEach (pack) ->
        output.push <Package key={ pack.get('name') } package={ pack } />
      output
    }
    </div>

module.exports = PackageList

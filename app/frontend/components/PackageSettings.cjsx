React = require 'react'
{connect} = require 'react-redux'

{
  settingsForPackageSelector
} = require '../selectors'

mapStateToProps =  (state, props) ->
  settings: settingsForPackageSelector state, props

mapDispatchToProps = {}

class PackageSettings extends React.Component
  render: ->
    {settings, packageId} = @props
    null

module.exports = connect(mapStateToProps, mapDispatchToProps) PackageSettings

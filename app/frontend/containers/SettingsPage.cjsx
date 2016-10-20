React = require 'react'
{connect} = require 'react-redux'
Package = require '../components/Package'
{filteredPackagesSelector} = require '../selectors'
classNames = require 'classnames'

mapStateToProps = (state, props) ->
  packages: filteredPackagesSelector state, props

mapDispatchToProps = {}

class SettingsPage extends React.Component
  shouldComponentUpdate: (nextProps, nextState) ->
    @props.packages isnt nextProps.packages
  render: ->
    {packages} = @props
    <div className="settingsPage">
    {
      packages.valueSeq().map (pack) ->
        <Package key={ pack.get('name') } packageId={ pack.get('name')} viewMode='settings'/>
    }
    </div>

module.exports = connect(mapStateToProps, mapDispatchToProps) SettingsPage

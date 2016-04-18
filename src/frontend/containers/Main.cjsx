React = require 'react'
PackageList = require '../components/PackageList'
{ connect } = require 'react-redux'
{ packages, commands } = require '../selectors'

stateToProps = (state) ->
    packages: packages state
    commands: commands state

PackageList = connect(stateToProps)(PackageList)
class Main extends React.Component
  @displayName: 'Main'
  componentWillMount: ->
    console.info 'Main props', arguments
  componentDidMount: ->
    emit 'applicationShouldStart'
  render: ->
    <PackageList/>

module.exports = Main

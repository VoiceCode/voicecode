React = require 'react'
PackageList = require '../components/PackageList'
class Main extends React.Component
  @displayName: 'Main'
  componentWillMount: ->
    console.info 'Main props', arguments
  componentDidMount: ->
    emit 'applicationShouldStart'
  render: ->
    <PackageList/>

module.exports = Main

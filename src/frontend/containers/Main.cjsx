React = require 'react'
PackageList = require '../components/PackageList'
class Main extends React.Component
  @displayName: 'Main'
  componentWillMount: ->
    console.info 'Main props', arguments
  componentDidMount: ->
    # emit 'applicationShouldStart'
  render: ->
    <div>
      <div className="ui inverted menu">
          <a className="active item">
            Packages
          </a>
      </div>
      <PackageList/>
    </div>

module.exports = Main

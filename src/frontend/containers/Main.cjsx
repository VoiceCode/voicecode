React = require 'react'
PackageList = require '../components/PackageList'
MainSearch = require '../components/MainSearch'
class Main extends React.Component
  @displayName: 'Main'
  componentWillMount: ->
    console.info 'Main props', arguments
  componentDidMount: ->
    # emit 'applicationShouldStart'
  render: ->
    <div>
      <div className="ui inverted menu">
          <a className="header item">
          VoiceCode
          </a>
          <a className="active item">
            Packages
          </a>
          <div className="right menu">
              <div className="item">
                <MainSearch/>
              </div>
            </div>
      </div>
      <PackageList/>
    </div>

module.exports = Main

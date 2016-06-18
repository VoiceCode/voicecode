React = require 'react'
{IndexLink, Link} = require 'react-router'
PackageList = require '../components/PackageList'
StickyButton = require '../components/StickyButton'
class Main extends React.Component
  componentDidMount: ->
    window.requestAnimationFrame ->
      setTimeout ->
        emit 'applicationShouldStart'
      , 500

  render: ->
    <div>
      <div className="ui top fixed inverted menu" style={WebkitAppRegion: "drag"}>
          <div className="header item" style={WebkitAppRegion: "drag"}>
          VoiceCode
          </div>
          <div className="right menu">
            <IndexLink to="/" className="item" activeClassName="active">Log</IndexLink>
            <Link to="/packages" className="item" activeClassName="active">Commands</Link>


            <StickyButton/>
          </div>
      </div>
      <div className='mainBody'>
        {@props.children}
      </div>
    </div>

module.exports = Main

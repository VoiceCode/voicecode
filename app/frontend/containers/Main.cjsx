React = require 'react'
{IndexLink, Link} = require 'react-router'
PackageList = require '../components/PackageList'
StickyButton = require '../components/StickyButton'
Footer = require '../components/Footer'

class Main extends React.Component
  componentDidMount: ->
    window.requestAnimationFrame ->
      setTimeout ->
        emit 'applicationShouldStart'
      , 500

  render: ->
    <div>
      <div className="ui top fixed inverted menu" style={WebkitAppRegion: "drag"}>
        <div className="right menu">
          <IndexLink to="/" className="item" activeClassName="active">Log</IndexLink>
          <Link to="/commands" className="item" activeClassName="active">Commands</Link>
          <Link to="/packages" className="item" activeClassName="active">Packages</Link>
          <StickyButton/>
        </div>
      </div>
      <div className='mainBody'>
        {@props.children}
      </div>
      <Footer/>
    </div>

module.exports = Main

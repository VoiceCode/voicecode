React = require 'react'
{IndexLink, Link} = require 'react-router'
PackageList = require '../components/PackageList'
PackageFilter = require '../components/PackageFilter'
class Main extends React.Component
  componentDidMount: ->
    emit 'applicationShouldStart'
  render: ->
    <div>
      <div className="ui top fixed inverted menu">
          <a className="header item">
          VoiceCode
          </a>
          <div className="right menu">
            <IndexLink to="/" className="item" activeClassName="active">Log</IndexLink>
            <Link to="/packages" className="item" activeClassName="active">Packages</Link>

            <div className="item">
              <PackageFilter/>
            </div>
          </div>
      </div>
      <div className='mainBody'>
        {@props.children}
      </div>
    </div>

module.exports = Main

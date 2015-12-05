React = require 'react'
Header = require '../layouts/Header.cjsx'
Body = require '../layouts/Body.cjsx'
Footer = require '../layouts/Footer.cjsx'

module.exports = React.createClass
    displayName: 'Main'
    render: ->
      <div>
        <Header/>
        <Body/>
        <Footer/>
      </div>

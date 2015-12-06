React = require 'react'
Header = require '../layouts/Header.cjsx'
Body = require '../layouts/Body.cjsx'
Footer = require '../layouts/Footer.cjsx'
View = require 'react-flexbox'

module.exports = React.createClass
    displayName: 'Main'
    render: ->
      <View row width='100%'>
        <View column width='100%'>
          <Header ref='Header' />
          <Body ref='Body' />
          <Footer ref='Footer' />
        </View>
      </View>

React = require 'react'
{ connect } = require 'react-redux'
Header = require '../components/Header.cjsx'
Body = require '../components/Body.cjsx'
Footer = require '../components/Footer.cjsx'
module.exports = class Main extends React.Component
  constructor: ->
    super
  componentDidMount: ->
    emit 'applicationShouldStart'
  render: ->
    console.error 'RENDERING MAIN'
    <div>
      <Body />
    </div>

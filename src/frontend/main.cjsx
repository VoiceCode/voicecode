(
  () ->
    React = require 'react'
    ReactDOM = require 'react-dom'
    Main = require './windows/Main.cjsx'
    remote = window.require 'remote'

    window.React = React
    ReactDOM.render <Main />, document.getElementById 'mount-point'
)()

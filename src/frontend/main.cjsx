(
  () ->
    React = require 'react'
    ReactDOM = require 'react-dom'
    Main = require './windows/Main.cjsx'
    window.remote = window.require 'remote'
    window._ = require 'lodash'
    window.Events = remote.getGlobal 'Events'
    window.emit = remote.getGlobal 'emit'
    renderMain = -> ReactDOM.render <Main />, document.getElementById 'mount-point'
    if remote.getGlobal('startedUp')?
      renderMain()
    else
      Events.on 'startupFlowComplete', => renderMain()

)()

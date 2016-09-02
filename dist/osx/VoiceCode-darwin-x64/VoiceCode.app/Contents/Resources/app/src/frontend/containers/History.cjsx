React = require 'react'
ChainList = require '../components/ChainList'
class History extends React.Component
  componentDidMount: ->
    store.actions.appStart()

  render: ->
    <div>
      <ChainList/>
    </div>

module.exports = History

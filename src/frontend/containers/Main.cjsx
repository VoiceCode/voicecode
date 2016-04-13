React = require 'react'
{ connect } = require 'react-redux'
# { packages, commands } = require '../selectors.coffee'
{ Header, Body, Footer } = require '../containers.coffee'
# ducks =
#   commands: require '../ducks/command.coffee'
#   packages: require '../ducks/package.coffee'
# actionCreators = _.reduce ducks, (actionCreators, duck, id) ->
#   _.extend actionCreators, duck.actionCreators
# , {}
#
# stateToProps = (state) -> {
#     packages: packages state
#     commands: commands state
#   }


class Main extends React.Component
  constructor: ->
    super
  componentDidMount: ->
    emit 'applicationShouldStart'
  render: ->
    console.error 'RENDERING MAIN'
    <div>
      <Body />
    </div>



# module.exports = connect(stateToProps, actionCreators)(Main)
module.exports = Main

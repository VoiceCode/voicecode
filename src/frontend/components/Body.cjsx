React = require 'react'
{ bindActionCreators } = require 'redux'
{ connect } = require 'react-redux'




{ packages, commands } = require '../selectors.coffee'
stateToProps = (state) ->
  console.info state
  return {
    packages: packages state
    commands: commands state
  }



PackageList = connect(stateToProps)(require '../components/PackageList.cjsx')


module.exports = class Body extends React.Component
  render: ->
    console.error 'RENDERING BODY'
    <PackageList />

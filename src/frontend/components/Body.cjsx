React = require 'react'
{ bindActionCreators } = require 'redux'
{ connect } = require 'react-redux'
PackageListPropMap = (state) ->
  packages: state.packages
  
PackageList = connect(PackageListPropMap)(require '../components/PackageList.cjsx')


module.exports = class Body extends React.Component
  render: ->
    console.error 'RENDERING BODY'
    <PackageList />

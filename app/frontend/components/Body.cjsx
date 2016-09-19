React = require 'react'
PackageList = require '../components/PackageList.cjsx'

module.exports = class Body extends React.Component
  render: ->
    <PackageList packages={@props.packages}/>

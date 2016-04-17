React = require 'react'
PackageList = require '../components/PackageList.cjsx'

module.exports = class Body extends React.Component
  render: ->
    console.error 'RENDERING BODY', @props
    <PackageList packages={@props.packages}/>

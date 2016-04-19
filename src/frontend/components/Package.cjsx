React = require 'react'
CommandList = require './CommandList.cjsx'
Package = class Package extends React.Component
  render: ->
    {name, description} = @props
    <div className="item">
      <div className="content">
        <div className="header">{ name }</div>
        <div className="meta">
          <span>{ description }</span>
        </div>
        <div className="description">
          <CommandList commands={ @props.commands } />
        </div>
        <div className="extra">
        </div>
      </div>
    </div>

module.exports = Package

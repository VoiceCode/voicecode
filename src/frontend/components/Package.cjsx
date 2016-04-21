React = require 'react'
CommandList = require './CommandList.cjsx'
{connect} = require 'react-redux'
{getPackage} = require '../selectors'

Package = class Package extends React.Component
  shouldComponentUpdate: (nextProps, nextState) ->
    @props.pack isnt nextProps.pack

  render: ->
    {name, description} = @props.pack.toJS()
    console.info "rendering package: #{name}"
    <div className="item">
      <div className="content">
        <div className="header">{ name }</div>
        <div className="meta">
          <span>{ description }</span>
        </div>
        <div className="description">
          <CommandList packageId={ name } />
        </div>
        <div className="extra">
        </div>
      </div>
    </div>

module.exports = Package

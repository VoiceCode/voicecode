React = require 'react'
CommandList = require './CommandList.cjsx'
ApiList = require './ApiList.cjsx'
{connect} = require 'react-redux'
{getPackage} = require '../selectors'

Package = class Package extends React.Component
  shouldComponentUpdate: (nextProps, nextState) ->
    @props.pack isnt nextProps.pack

  render: ->
    {name, description} = @props.pack
    console.info "rendering package: #{name}"
    <div className=''>
      <div className="ui top attached huge block header">
        <i className="cube icon"></i>
        <div className='content'>
          { name }
          <div className="sub header">
          { description }
          </div>
        </div>
      </div>
      <div className="ui attached segment">
        <CommandList packageId={ name } />
      </div>
      <div className="ui attached segment">
        <ApiList packageId={ name } />
      </div>
    </div>

module.exports = Package

React = require 'react'
{connect} = require 'react-redux'
{makeFilteredCommandsForPackage,
packageFilterSelector,
packageSelector,
} = require '../selectors'

makeMapStateToProps = (state, props)->
  filteredCommandsForPackage = makeFilteredCommandsForPackage()
  (state, props) ->
    commands: filteredCommandsForPackage state, props
    packageFilter: packageFilterSelector state, props
    pack: packageSelector state, props
CommandList = require './CommandList.cjsx'
# CommandList = connect(makeMapStateToProps) CommandList

ApiList = require './ApiList.cjsx'
{connect} = require 'react-redux'
{getPackage} = require '../selectors'

Package = class Package extends React.Component
  shouldComponentUpdate: (nextProps, nextState) ->
    pack = @props.pack isnt nextProps.pack
    commands = @props.commands isnt nextProps.commands
    scope = @props.packageFilter.get('scope') isnt nextProps.packageFilter.get('scope')
    pack or commands or scope
  render: ->
    {name, description} = @props.pack
    {packageFilter, commands} = @props
    console.info "rendering package"
    return null unless commands.size
    <div className=''>
      {
        if packageFilter.get('scope') is 'packages'
          <div className="ui top attached huge block header">
            <i className="cube icon"></i>
            <div className='content'>
              { name }
              <div className="sub header">
                { description }
              </div>
            </div>
          </div>
      }
      <div className="ui attached segment">
        <CommandList packageId={ name } commands={ commands }/>
      </div>
      {
        if packageFilter.get('scope') is 'packages'
          <div className="ui attached segment">
            <ApiList packageId={ name } />
          </div>
      }
    </div>

module.exports = connect(makeMapStateToProps) Package

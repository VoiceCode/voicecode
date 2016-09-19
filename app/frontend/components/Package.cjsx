React = require 'react'
{connect} = require 'react-redux'
{makeFilteredCommandsForPackage,
packageFilterSelector,
packageSelector,
commandSelector
} = require '../selectors'
CommandList = require './CommandList.cjsx'
{installPackage, removePackage} = require('../ducks/package').actionCreators
ApiList = require './ApiList.cjsx'
{connect} = require 'react-redux'
{getPackage} = require '../selectors'

# https://github.com/reactjs/reselect#sharing-selectors-with-props-across-multiple-components
makeMapStateToProps = (state, props)->
  filteredCommandsForPackage = makeFilteredCommandsForPackage()
  (state, props) ->
    commands: filteredCommandsForPackage state, props
    packageFilter: packageFilterSelector state, props
    pack: packageSelector state, props
mapDispatchToProps = {installPackage, removePackage}

Package = class Package extends React.Component
  shouldComponentUpdate: (nextProps, nextState) ->
    pack = @props.pack isnt nextProps.pack
    commands = @props.commands isnt nextProps.commands
    scope = @props.packageFilter.get('scope') isnt nextProps.packageFilter.get('scope')
    pack or commands or scope
  render: ->
    {name, description, installed} = @props.pack
    {packageFilter, commands, viewMode, installPackage, removePackage} = @props
    <div className=''>
    {
      if packageFilter.get('scope') is 'packages' or viewMode isnt 'commands'
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
    {
      if viewMode is 'commands'
        <div className=''>
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
      else
        <div className="ui attached segment">
        {
          if installed
            <button className="ui red tiny icon button" onClick={ removePackage.bind null, name }>
              <i className="trash outline icon"></i>
            </button>
          else
            <button className="ui green tiny icon button" onClick={ installPackage.bind null, name }>
              <i className="download icon"></i>
            </button>
        }
        </div>
    }
    </div>

module.exports = connect(makeMapStateToProps, mapDispatchToProps) Package

React = require 'react'
{connect} = require 'react-redux'
{
  makeFilteredCommandsForPackage,
  packageFilterSelector,
  packageSelector,
  commandSelector
} = require '../selectors'
CommandList = require './CommandList.cjsx'
{
  shouldInstallPackage,
  shouldRemovePackage,
  shouldUpdatePackage,
  revealPackageOrigin,
  revealPackageSource
} = require('../ducks/package').actionCreators
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
mapDispatchToProps = {
  shouldInstallPackage,
  shouldRemovePackage,
  shouldUpdatePackage,
  revealPackageOrigin,
  revealPackageSource
}

Package = class Package extends React.Component
  shouldComponentUpdate: (nextProps, nextState) ->
    pack = @props.pack isnt nextProps.pack
    commands = @props.commands isnt nextProps.commands
    scope = @props.packageFilter.get('scope') isnt nextProps.packageFilter.get('scope')
    pack or commands or scope
  render: ->
    {name, description, installed, repoStatus} = @props.pack
    {packageFilter,
    commands,
    viewMode,
    shouldInstallPackage,
    shouldRemovePackage,
    shouldUpdatePackage,
    revealPackageOrigin
    revealPackageSource,
    } = @props
    <div className='package'>
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
        <div className="ui attached icon menu">
        {
          if installed
            <a className="item"
                    onClick={ shouldRemovePackage.bind null, name }>
              <i className="trash icon"></i>
            </a>
        }{
          if not installed
            <a className="item"
                    onClick={ shouldInstallPackage.bind null, name }>
              <i className="download icon"></i>
            </a>
        }

        <div className='right icon menu'>
          {
            if installed and true #repoStatus.behind
              <a className="item"
                      onClick={ shouldUpdatePackage.bind null, name }>
                <i className="yellow arrow circle up icon"></i>
              </a>
          }
          {
            if installed
              <a className="item"
                      onClick={ revealPackageSource.bind null, name }>
                <i className="code icon"></i>
              </a>
          }
          <a className='item inverted'
                onClick={ revealPackageOrigin.bind null, name }>
              <i className="gitlab icon"></i>
          </a>
        </div>
        </div>
    }
    </div>

module.exports = connect(makeMapStateToProps, mapDispatchToProps) Package

React = require 'react'
{connect} = require 'react-redux'
CommandList = require './CommandList.cjsx'
ApiList = require './ApiList.cjsx'
PackageSettings = require './PackageSettings.cjsx'
PackageImplementationList = require './PackageImplementationList.cjsx'

{
  makeFilteredCommandsForPackage,
  packageFilterSelector,
  commandFilterSelector,
  packageSelector,
  commandSelector
} = require '../selectors'

{
  shouldInstallPackage,
  shouldRemovePackage,
  shouldUpdatePackage,
  revealPackageOrigin,
  revealPackageSource
} = require('../ducks/package').actionCreators
# {getPackage} = require '../selectors'
currentFilterSelector = (state, {viewMode}) ->
  if viewMode is 'commands'
    commandFilterSelector.apply null, arguments
  else
    packageFilterSelector.apply null, arguments

# https://github.com/reactjs/reselect#sharing-selectors-with-props-across-multiple-components
makeMapStateToProps = (state, props)->
  filteredCommandsForPackage = makeFilteredCommandsForPackage()
  (state, props) ->
    commands: filteredCommandsForPackage state, props
    currentFilter: currentFilterSelector state, props
    pack: packageSelector state, props
mapDispatchToProps = {
  shouldInstallPackage,
  shouldRemovePackage,
  shouldUpdatePackage,
  revealPackageOrigin,
  revealPackageSource
}

Package = class Package extends React.Component
  # componentDidMount: ->
  #   $('.withRightTooltip').popup
  #     on: 'hover'
  #     position: 'bottom right'
  #     delay:
  #       show: 500
  #       hide: 0
  #   $('.withLeftTooltip').popup
  #     on: 'hover'
  #     position: 'top right'
  #     delay:
  #       show: 500
  #       hide: 0
  shouldComponentUpdate: (nextProps, nextState) ->
    pack = @props.pack isnt nextProps.pack
    commands = @props.commands isnt nextProps.commands
    scope = @props.currentFilter.get('scope') isnt nextProps.currentFilter.get('scope')
    pack or commands or scope
  render: ->
    {
      name,
      description,
      installed,
      repoStatus,
      repoLog
    } = @props.pack
    {
      currentFilter,
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
      if currentFilter.get('scope') is 'packages' or viewMode isnt 'commands'
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
            if currentFilter.get('scope') is 'packages'
              <div className=''>
                <div className="ui attached segment">
                  <PackageImplementationList packageId={ name } />
                </div>
                <div className="ui attached segment">
                  <ApiList packageId={ name } />
                </div>
              </div>
          }
        </div>
      else if viewMode is 'packages'
        <div className=''>
          <div className="ui attached icon menu">
          {
            if installed
              <a className="item " title="remove package"
                      onClick={ shouldRemovePackage.bind null, name }>
                <i className="trash outline icon"></i>
              </a>
          }{
            if not installed
              <a className="item" title="install package"
                      onClick={ shouldInstallPackage.bind null, name }>
                <i className="download icon"></i>
              </a>
          }

            <div className='right icon menu'>
              {
                if installed and repoStatus.behind
                  <a className="item" title="update package"
                          onClick={ shouldUpdatePackage.bind null, name }>
                    <i className="yellow arrow circle up icon"></i>
                  </a>
              }
              {
                if installed
                  <a className="item" title="reveal package"
                          onClick={ revealPackageSource.bind null, name }>
                    <i className="code icon"></i>
                  </a>
              }
              <a className='item inverted' title="go to repository"
                    onClick={ revealPackageOrigin.bind null, name }>
                  <i className="gitlab icon"></i>
              </a>
            </div>
          </div>
        {
          <div className="ui attached segment">
            {
              unless _.isEmpty repoLog
                <div className='ui divided list'>
                  {
                    _.map repoLog, (commit) ->
                        <div className='item' key={ commit.commit }>
                          <i className='file code outline middle aligned icon'></i>
                          <div className='content'>
                            <div className='header'>{ _.startCase commit.message }</div>
                            <div className='description'>{ commit.date }</div>
                          </div>
                        </div>
                  }
                </div>
            }
          </div>
        }
        </div>
      else if viewMode is 'settings'
        <PackageSettings packageId={ name }/>
    }
    </div>

module.exports = connect(makeMapStateToProps, mapDispatchToProps) Package

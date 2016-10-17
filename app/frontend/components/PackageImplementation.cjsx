React = require 'react'
{ connect } = require 'react-redux'
classNames = require 'classnames'
{implementationSelector} = require '../selectors'

mapStateToProps = (state, props) ->
  implementation: implementationSelector state, props

mapDispatchToProps = {} # maybe add a "reveal command" action

class PackageImplementation extends React.Component
  shouldComponentUpdate: (nextProps, nextState) ->
    false

  render: ->
    {id, scope, originalPackageId, commandId} = @props.implementation.toJS()
    <div className="item">
      <div className="content">
        <div className="header">
          <i className='small grey plus-network icon'></i>
          <div className="meta">{ id }</div>
        </div>
      </div>
    </div>

module.exports = connect(mapStateToProps)(PackageImplementation)

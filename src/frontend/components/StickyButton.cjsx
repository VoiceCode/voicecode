{connect} = require 'react-redux'
React = require 'react'
classNames = require 'classnames'
{toggleStickyWindow} = require('../ducks/app').actionCreators

stateProps = (state) ->
  isSticky: state.get 'stickyWindow'
dispatchProps = {toggleStickyWindow}

class StickyButton extends React.Component
  shouldComponentUpdate: ->
    console.log arguments
    true
  render: ->
    {isSticky, toggleStickyWindow} = @props
    console.log isSticky
    stickyWindowIconClasses = classNames
      'inverted icon zeroMargin': true
      'lock': isSticky
      'unlock': !isSticky
    <div className='item' onClick={ toggleStickyWindow }>
      <i className={ stickyWindowIconClasses }></i>
    </div>

module.exports = connect(stateProps, dispatchProps) StickyButton

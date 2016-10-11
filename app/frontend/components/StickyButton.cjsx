{connect} = require 'react-redux'
React = require 'react'
classNames = require 'classnames'
{toggleStickyWindow} = require('../ducks/app').actionCreators

stateProps = (state) ->
  isSticky: state.get 'sticky_window'
dispatchProps = {toggleStickyWindow}

class StickyButton extends React.Component
  shouldComponentUpdate: (nextProps, nextState)->
    @props.isSticky isnt nextProps.isSticky

  render: ->
    {isSticky, toggleStickyWindow} = @props
    stickyWindowIconClasses = classNames
      'inverted icon zeroMargin': true
      'lock': isSticky
      'unlock': !isSticky
    <a className='item'
       onClick={ toggleStickyWindow }
       title='toggle window hover'>
      <i className={ stickyWindowIconClasses }></i>
    </a>

module.exports = connect(stateProps, dispatchProps) StickyButton

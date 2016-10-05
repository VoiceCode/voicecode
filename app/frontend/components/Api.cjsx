React = require 'react'
{ connect } = require 'react-redux'
classNames = require 'classnames'

class Api extends React.Component
  shouldComponentUpdate: (nextProps, nextState) ->
    false

  render: ->
    {name, signature, description, shorthandFor} = @props.api.toJS()
    <div className="item">
      <div className="content">
        <div className="header">
        {
          if shorthandFor
              <i className='small grey external square icon'></i>
            else
              <i className='small grey plug icon'></i>
        }
        { signature or "#{name}: signature missing" }
        </div>
        <div className='meta'>{ description || "Shorthand for #{shorthandFor}" }</div>
      </div>
    </div>

module.exports = Api

React = require 'react'
classNames = require 'classnames'

class LogEntry extends React.Component
  shouldComponentUpdate: -> false
  render: ->
    {timestamp, event, type, args} = @props.log.toJS()
    iconClasses = classNames
      'icon inverted circular small': true
      'yellow wizard': type is 'mutate'
      'orange warning sign': type is 'warning'
      'purple announcement': type is 'notify'
      'black bug': type is 'debug'
      'red warning sign': type is 'error'
      'grey lightning': type is 'event'
      'olive info': type is 'log'
      'blue terminal': type is 'stdout'
      'red terminal': type is 'stderr'
    titleClasses = classNames
      'title': true
      'active': developmentMode
    contentClasses = classNames
      'content': true
      'active': developmentMode
    <div className="">
      <div className={ titleClasses }>
        <i className={ iconClasses }></i>
        { event }
      </div>
      {
        if args?
          <div className={ contentClasses }>
            <pre className="ui inverted message">
            { args }
            </pre>
          </div>
        }
    </div>




module.exports = LogEntry

React = require 'react'
LogEntry = require '../components/LogEntry'
{connect} = require 'react-redux'
accordion = require('semantic-ui-css/components/accordion.js')
{toggleLogEvents} = require('../ducks/app').actionCreators
classNames = require 'classnames'

mapStateToProps = (state) ->
  logs: state.get 'logs'
  logEvents: state.get 'logEvents'
mapDispatchToProps = {toggleLogEvents}

class LogPage extends React.Component
  componentDidMount: ->
    unless developmentMode
      $('.ui.accordion').accordion
        on: 'mouseover'
  render: ->
    {logEvents, toggleLogEvents} = @props
    logEventsClasses = classNames
      item: true
      active: logEvents

    <div className="logPage">
      <div className='ui fixed secondary pointing page menu'>
        <a className={ logEventsClasses } onClick={ toggleLogEvents }>
          <i className='bug icon'></i>
        </a>
      </div>
      <div className="ui styled fluid accordion">
      {
        @props.logs.map (log) ->
           <LogEntry
             key={log.get('timestamp').join('')}
             log={log}
           />
       }
      </div>
    </div>

module.exports = connect(mapStateToProps, mapDispatchToProps) LogPage

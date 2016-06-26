React = require 'react'
LogEntry = require '../components/LogEntry'
{connect} = require 'react-redux'
accordion = require('semantic-ui-css/components/accordion.js')
{showingEventsSelector} = require('../selectors')
{toggleLogEvents} = require('../ducks/app').actionCreators
classNames = require 'classnames'

mapStateToProps = (state) ->
  logs: state.get 'logs'
  showingEvents: showingEventsSelector state
mapDispatchToProps = {toggleLogEvents}

class LogPage extends React.Component
  componentDidMount: ->
    unless developmentMode
      $('.ui.accordion').accordion
        on: 'click'
  render: ->
    {showingEvents, toggleLogEvents} = @props
    logEventsClasses = classNames
      item: true
      active: showingEvents

    <div className="logPage">
      <div className='ui fixed secondary pointing page menu'>
        <a className={ logEventsClasses } onClick={ toggleLogEvents }>
          <i className='lab icon'></i>
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

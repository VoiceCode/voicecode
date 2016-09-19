React = require 'react'
LogEntry = require '../components/LogEntry'
{connect} = require 'react-redux'
accordion = require('semantic-ui-css/components/accordion.js')
{showingEventsSelector} = require('../selectors')
{toggleLogEvents} = require('../ducks/app').actionCreators
{clearLog} = require('../ducks/log').actionCreators
classNames = require 'classnames'

mapStateToProps = (state) ->
  logs: state.get 'logs'
  showingEvents: showingEventsSelector state
mapDispatchToProps = {toggleLogEvents, clearLog}

class LogPage extends React.Component
  componentDidMount: ->
    unless developmentMode
      $('.ui.accordion').accordion
        on: 'click'
  render: ->
    {showingEvents, toggleLogEvents, clearLog} = @props
    logEventsClasses = classNames
      active: showingEvents
      item: true

    <div className="logPage">
      <div className='ui fixed secondary pointing page menu'>
        <a className={ logEventsClasses } onClick={ toggleLogEvents }>
          <i className='lab icon'></i>
        </a>
        <a className={ 'item' } onClick={ clearLog }>
          <i className='trash outline icon'></i>
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

React = require 'react'
LogEntry = require '../components/LogEntry'
{connect} = require 'react-redux'
accordion = require('semantic-ui-css/components/accordion.js')
{showingEventsSelector, radioSilenceSelector} = require('../selectors')
{toggleLogEvents, toggleRadioSilence} = require('../ducks/app').actionCreators
{clearLog} = require('../ducks/log').actionCreators
classNames = require 'classnames'

mapStateToProps = (state) ->
  logs: state.get 'logs'
  showingEvents: showingEventsSelector state
  radioSilence: radioSilenceSelector state
mapDispatchToProps = {toggleLogEvents, clearLog, toggleRadioSilence}

class LogPage extends React.Component
  componentDidMount: ->
    unless developmentMode
      $('.ui.accordion').accordion
        on: 'click'
  render: ->
    {showingEvents
    , toggleLogEvents
    , clearLog
    , toggleRadioSilence
    , radioSilence} = @props

    logEventsClasses = classNames
      active: showingEvents
      item: true
    radioSilenceClasses = classNames
      active: radioSilence
      item: true

    <div className="logPage">
      <div className='ui fixed secondary pointing page menu'>
        <a className={ logEventsClasses } onClick={ toggleLogEvents }>
          <i className='bug icon'></i>
        </a>
        <a className={ radioSilenceClasses } onClick={ toggleRadioSilence }>
          <i className='pause circle icon'></i>
        </a>

        <div className="right menu">
          <a className={ 'item' } onClick={ clearLog }>
            <i className='trash outline icon'></i>
          </a>
        </div>
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

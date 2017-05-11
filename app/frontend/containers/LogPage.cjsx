React = require 'react'
LogEntry = require '../components/LogEntry'
{connect} = require 'react-redux'
# accordion = require('semantic-ui-css/components/accordion.js')
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
  shouldComponentUpdate: ->
    Remote.getGlobal('windowController').get('main').isVisible()
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
        <a className={ logEventsClasses } onClick={ toggleLogEvents } title="toggle debug mode">
          <i className='bug icon'></i>
          Debug
        </a>
        <a className={ radioSilenceClasses } onClick={ toggleRadioSilence } title="toggle logging" title='pause'>
          <i className='pause circle icon'></i>
          Pause
        </a>

        <div className="right menu">
          <a className={ 'item' } onClick={ clearLog } title="clear log">
            <i className='trash outline icon'></i>
            Clear
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

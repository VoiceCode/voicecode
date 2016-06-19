React = require 'react'
LogEntry = require '../components/LogEntry'
{connect} = require 'react-redux'
mapStateToProps = (state) ->
  logs: state.get 'logs'
accordion = require('semantic-ui-css/components/accordion.js')
class LogPage extends React.Component
  componentDidMount: ->
    unless developmentMode
      $('.ui.accordion').accordion
        on: 'mouseover'
  render: ->
    <div className="">
      <div className='ui fixed secondary pointing page menu'>
        <a className='item'>
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

module.exports = connect(mapStateToProps) LogPage

React = require 'react'
LogEntry = require '../components/LogEntry'
{connect} = require 'react-redux'
mapStateToProps = (state) ->
  logs: state.logs
accordion = require('semantic-ui-css/components/accordion.js')
class LogPage extends React.Component
  shouldComponentUpdate: (nextProps, nextState) ->
    @props.logs isnt nextProps.logs
  componentDidMount: ->
    unless developmentMode
      $('.ui.accordion').accordion
        on: 'mouseover'
  render: ->
    <div className="">
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

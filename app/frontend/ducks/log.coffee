immutable = require 'immutable'
{createAction} = require 'redux-actions'

constants =
  CREATE_LOG_ENTRY: 'CREATE_LOG_ENTRY'
  CLEAR_LOG: 'CLEAR_LOG'

_.extend @, constants
_.extend exports, constants

actionCreators =
  createLogEntry: createAction(@CREATE_LOG_ENTRY)
  clearLog: createAction(@CLEAR_LOG)

# thunk
actionCreators.toggleEventDebug = (id, enabled) ->
  (dispatch, getState) ->
    emit 'toggleEventDebug'
    if showingEventsSelector getState()
      dispatch actionCreators.hideEvents
    else
      dispatch actionCreators.showEvents

exports.actionCreators = actionCreators

logEntryRecord = immutable.Record
  type: null
  timestamp: null
  event: null
  args: null

exports.reducers =
  logs: (logs = immutable.List([]), {type, payload}) =>
    switch type
      when @CREATE_LOG_ENTRY
        logEntry = new logEntryRecord payload
        logs = logs.insert 0, logEntry
        if logs.size is 50 and not developmentMode
          return logs.setSize 50
        logs
      when @CLEAR_LOG
        immutable.List []
      else
        logs

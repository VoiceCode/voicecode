{ createAction } = require 'redux-actions'
immutable = require 'immutable'
constants =
  ENABLE_COMMAND: 'ENABLE_COMMAND'
  DISABLE_COMMAND: 'DISABLE_COMMAND'
  CREATE_COMMAND: 'CREATE_COMMAND'

_.extend @, constants
_.extend exports, constants

actionCreators =
  createCommand: createAction(@CREATE_COMMAND)
  enableCommand: createAction(@ENABLE_COMMAND)
  disableCommand: createAction(@DISABLE_COMMAND)

actionCreators.toggleCommand = (id, enabled) ->
  (dispatch, getState) ->
    if enabled
      emit 'enableCommand', id
    else
      emit 'disableCommand', id

exports.actionCreators = actionCreators

commandRecord = immutable.Record
  id: 'unknown'
  spoken: 'inaudible'
  enabled: false
  packageId: 'os'
  description: 'no description'

exports.reducers =
  commands: (commands = immutable.Map({}), {type, payload}) =>
    switch (type)
      when @CREATE_COMMAND
        command = new commandRecord payload
        commands.set payload.id, command

      when @ENABLE_COMMAND
        commands.setIn [payload.id, 'enabled'], true
      when @DISABLE_COMMAND
        commands.setIn [payload.id, 'enabled'], false
      else
        commands

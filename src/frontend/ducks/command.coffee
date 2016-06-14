immutable = require 'immutable'
{createAction} = require 'redux-actions'
{CREATE_IMPLEMENTATION} = require './implementation'

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

# thunk
actionCreators.toggleCommand = (id, enabled) ->
  (dispatch, getState) ->
    if enabled
      emit 'enableCommand', id
    else
      emit 'disableCommand', id

exports.actionCreators = actionCreators

commandRecord = immutable.Record
  id: null
  spoken: null
  enabled: false
  packageId: 'unpackaged'
  description: 'no description'
  locked: false

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
  command_implementations: (ci = immutable.Map({}), {type, payload}) =>
    switch type
      when @CREATE_COMMAND
        ci.set payload.id, immutable.List []
      when CREATE_IMPLEMENTATION
        ci.updateIn [payload.commandId]
        , (list) -> list.push payload.packageId
      else
        ci

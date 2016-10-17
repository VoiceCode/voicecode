immutable = require 'immutable'
{createAction} = require 'redux-actions'
{CREATE_IMPLEMENTATION} = require './implementation'

constants =
  ENABLE_COMMAND: 'ENABLE_COMMAND'
  DISABLE_COMMAND: 'DISABLE_COMMAND'
  CREATE_COMMAND: 'CREATE_COMMAND'
  CHANGE_SPOKEN: 'CHANGE_SPOKEN'
_.extend @, constants
_.extend exports, constants

actionCreators =
  createCommand: createAction(@CREATE_COMMAND)
  enableCommand: createAction(@ENABLE_COMMAND)
  disableCommand: createAction(@DISABLE_COMMAND)
  changeSpoken: createAction(@CHANGE_SPOKEN)
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
  rule: null
  spoken: null
  locked: false
  enabled: false
  packageId: 'unpackaged'
  description: 'No description'
  internal: false
  tags: []
  variables: []

exports.reducers =
  commands: (commands = immutable.Map({}), {type, payload}) =>
    switch (type)
      when @CHANGE_SPOKEN
        commands.setIn [payload.id, 'spoken'], payload.spoken
      when @CREATE_COMMAND
        command = new commandRecord payload
        commands.set payload.id, command
      when @ENABLE_COMMAND
        commands.setIn [payload.id, 'enabled'], true
      when @DISABLE_COMMAND
        commands.setIn [payload.id, 'enabled'], false
      else
        commands
  command_implementations: (implementations = immutable.Map({}), {type, payload}) =>
    switch type
      when @CREATE_COMMAND
        implementations.set payload.id, immutable.List []
      when CREATE_IMPLEMENTATION
        implementations.updateIn [payload.commandId]
        , (list) -> list.push payload.id
      else
        implementations

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
exports.reducer = (commands, {type, payload}, Command, session) =>
  switch (type)
    when @CREATE_COMMAND
      command = _.pick(payload, ['id', 'spoken', 'enabled', 'packageId', 'description'])
      Command.create(command)
    when @ENABLE_COMMAND
      Command.withId(payload.id).set('enabled', true)
    when @DISABLE_COMMAND
      Command.withId(payload.id).set('enabled', false)
  Command.getNextState()

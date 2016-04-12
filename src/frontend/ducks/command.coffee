{ createAction } = require 'redux-actions'
immutable = require 'immutable'
exports.ENABLE_COMMAND = ENABLE_COMMAND = 'ENABLE_COMMAND'
exports.DISABLE_COMMAND = DISABLE_COMMAND = 'DISABLE_COMMAND'
exports.CREATE_COMMAND = CREATE_COMMAND = 'CREATE_COMMAND'

exports.actionCreators =
  createCommand: createAction(CREATE_COMMAND)
  enableCommand: createAction(ENABLE_COMMAND)
  disableCommand: createAction(DISABLE_COMMAND)

exports.reducer = (commands = {}, {type, payload}) ->
  switch type
    when CREATE_COMMAND
      console.log 'COMMANDS COMMANDS COMMANDS '
      commands.update payload.id, -> immutable.fromJS
        id: payload.id
        spoken: payload.spoken
        enabled: payload.enabled
    when ENABLE_COMMAND
      commands.updateIn [payload, 'enabled'], (value) -> true
    when DISABLE_COMMAND
      commands.updateIn [payload, 'enabled'], (value) -> false
    else
      commands

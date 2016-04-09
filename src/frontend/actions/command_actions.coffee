exports.ENABLE_COMMAND = 'command_actions/enable'
exports.COMMAND_SHOULD_ENABLE = 'command_actions/should_enable'
exports.COMMAND_DID_ENABLE = 'command_actions/did_enable'
exports.DISABLE_COMMAND = 'command_actions/disable'
exports.COMMAND_SHOULD_DISABLE = 'command_actions/should_disable'
exports.COMMAND_DID_DISABLE = 'command_actions/did_disable'

exports.enableCommand = (id) ->
  return {
    type: ENABLE_COMMAND
    id
  }

exports.disableCommand = (id) ->
  return {
    type: DISABLE_COMMAND
    id
  }

{ createAction } = require 'redux-actions'
immutable = require 'immutable'
constants =
  CREATE_IMPLEMENTATION: 'CREATE_IMPLEMENTATION'
  # ENABLE_IMPLEMENTATION: 'ENABLE_IMPLEMENTATION'
  # DISABLE_IMPLEMENTATION: 'DISABLE_IMPLEMENTATION'

_.extend @, constants
_.extend exports, constants

actionCreators =
  createImplementation: createAction(@CREATE_IMPLEMENTATION)

# thunk
actionCreators.implementationCreated = ({commandId, implementations}) ->
  (dispatch, getState) ->
    state = getState()
    current = state.command_implementations.get(commandId).toJS()
    added = _.difference implementations, current
    added = added.pop()
    if added?
      dispatch actionCreators.createImplementation
        packageId: added
        commandId: commandId

exports.actionCreators = actionCreators

# exports.reducers =
#   implementations: (implementations = immutable.Map({}), {type, payload}) =>
#     switch type
#       else
#         implementations

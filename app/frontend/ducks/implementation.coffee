{ createAction } = require 'redux-actions'
immutable = require 'immutable'

constants =
  CREATE_IMPLEMENTATION: 'CREATE_IMPLEMENTATION'
  REMOVE_IMPLEMENTATION: 'REMOVE_IMPLEMENTATION'
  # ENABLE_IMPLEMENTATION: 'ENABLE_IMPLEMENTATION'
  # DISABLE_IMPLEMENTATION: 'DISABLE_IMPLEMENTATION'

_.extend @, constants
_.extend exports, constants

actionCreators =
  createImplementation: createAction(@CREATE_IMPLEMENTATION)

# thunk
actionCreators.implementationCreated = ({commandId, originalPackageId, implementations}) ->
  (dispatch, getState) ->
    state = getState()
    current = state.get('command_implementations').get(commandId).toJS()
    difference = _.difference _.keys(implementations), _.keys(current)
    difference = difference.pop()
    if difference?
      added = implementations[difference]
      if added
        dispatch actionCreators.createImplementation
          id: difference
          originalPackageId: originalPackageId
          packageId: added.packageId
          scope: added.scope
          commandId: commandId
      else
        removed = current[difference]
        if removed
          dispatch actionCreators.removeImplementation
            id: difference

exports.actionCreators = actionCreators

implementationRecord = immutable.Record
  id: null
  originalPackageId: null
  packageId: null
  commandId: null
  scope: null

exports.reducers =
  implementations: (implementations = immutable.Map({}), {type, payload}) =>
    switch type
      when @CREATE_IMPLEMENTATION
        record = new implementationRecord payload
        implementations.set payload.id, record
        # when @REMOVE_IMPLEMENTATION
        #   todo
      else
        implementations

{ createAction } = require 'redux-actions'
immutable = require 'immutable'
constants =
  CREATE_IMPLEMENTATION: 'CREATE_IMPLEMENTATION'
  # ENABLE_IMPLEMENTATION: 'ENABLE_IMPLEMENTATION'
  # DISABLE_IMPLEMENTATION: 'DISABLE_IMPLEMENTATION'

_.extend @, constants
_.extend exports, constants

exports.actionCreators =
  createImplementation: createAction(@CREATE_IMPLEMENTATION)

exports.reducers =
  implementations: (implementations = immutable.Map({}), {type, payload}) =>
    switch type
      when @CREATE_IMPLEMENTATION
        packageId = _.difference payload.implementations, _.keys implementations
        packageId = packageId.pop()
        implementation = {packageId, commandId: payload.commandId}
        Implementation.create implementation
      else
        implementations

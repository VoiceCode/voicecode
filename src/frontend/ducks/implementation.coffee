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

exports.reducer = (implementations, {type, payload}, Implementation, session) =>
  switch type
    when @CREATE_IMPLEMENTATION
      console.log 'create implementation'
  Implementation.getNextState()

{ createAction } = require 'redux-actions'
immutable = require 'immutable'
constants =
  CREATE_API: 'CREATE_API'

_.extend @, constants
_.extend exports, constants

actionCreators =
  createApi: createAction(@CREATE_API)

exports.actionCreators = actionCreators

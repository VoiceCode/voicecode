{ createAction } = require 'redux-actions'
immutable = require 'immutable'

constants =
  UPDATE_SETTINGS: 'UPDATE_SETTINGS'

_.extend @, constants
_.extend exports, constants

actionCreators =
  updateSettings: createAction(@UPDATE_SETTINGS)

# thunk


exports.actionCreators = actionCreators
exports.reducers =
  settings: (settings = immutable.Map({}), {type, payload}) =>
    switch type
      when @UPDATE_SETTINGS
        settings.set payload.pack.name, payload.pack._settings
        # when @REMOVE_IMPLEMENTATION
        #   todo
      else
        settings

{ createAction } = require 'redux-actions'

# 😂
actionCreators = _.reduce {
    SET_CURRENT_APPLICATION: 'SET_CURRENT_APPLICATION'
}
, (ac, c) =>
  ac[_.camelCase(c)] = createAction c
  @[c] = c
  exports[c] = c
  ac
, {}

# thunk
actionCreators.appStart = ->
  (dispatch, getState) ->
    dispatch {type: '__IMMUTABLE'}

module.exports.actionCreators = actionCreators

exports.reducers =
  isImmutable: (state = {isImmutable: false}) -> state
  currentApplication: (state = '', {type, payload}) =>
    switch type
      when @SET_CURRENT_APPLICATION
        state = payload.name
      else
        state

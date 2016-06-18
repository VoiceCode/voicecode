{ createAction } = require 'redux-actions'

# 😂
actionCreators = _.reduce {
  SET_CURRENT_APPLICATION: 'SET_CURRENT_APPLICATION'
  SET_STICKY_WINDOW: 'SET_STICKY_WINDOW'
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

actionCreators.toggleStickyWindow = ->
  (dispatch, getState) ->
    shouldStick = not getState().stickyWindow
    dispatch actionCreators.setStickyWindow shouldStick
    emit 'toggleStickyWindow',
      id: 'main',
      shouldStick: shouldStick

module.exports.actionCreators = actionCreators

exports.reducers =
  # isImmutable: (state = true) -> state # not a 🐛
  stickyWindow: (state = false, {type, payload}) =>
    if type is @SET_STICKY_WINDOW then payload else state
  currentApplication: (state = '', {type, payload}) =>
    switch type
      when @SET_CURRENT_APPLICATION
        state = payload.name
      else
        state

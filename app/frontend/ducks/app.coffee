{createAction} = require 'redux-actions'
{push} = require('react-router-redux')

# 😂
actionCreators = _.reduce {
  SET_CURRENT_APPLICATION: 'SET_CURRENT_APPLICATION'
  SET_STICKY_WINDOW: 'SET_STICKY_WINDOW'
  SET_LOG_EVENTS: 'SET_LOG_EVENTS'
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
    shouldStick = not getState().get 'stickyWindow'
    dispatch actionCreators.setStickyWindow shouldStick
    emit 'toggleStickyWindow',
      id: 'main',
      shouldStick: shouldStick

actionCreators.toggleLogEvents = ->
  (dispatch, getState) ->
    logEvents = not getState().get 'logEvents'
    dispatch actionCreators.setLogEvents logEvents
    emit 'logEvents', logEvents

_.extend actionCreators, changePage: (page = '/') ->
  (dispatch, getState) ->
    dispatch push "/#{page}".replace '//', '/'


module.exports.actionCreators = actionCreators

exports.reducers =
  isImmutable: (state = true) -> state # not a 🐛
  logEvents: (state = developmentMode, {type, payload}) =>
    if type is @SET_LOG_EVENTS then payload else state
  stickyWindow: (state = false, {type, payload}) =>
    if type is @SET_STICKY_WINDOW then payload else state
  currentApplication: (state = '', {type, payload}) =>
    switch type
      when @SET_CURRENT_APPLICATION
        state = payload.name
      else
        state

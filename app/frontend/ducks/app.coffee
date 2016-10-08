{createAction} = require 'redux-actions'
{push} = require('react-router-redux')

# 😂
actionCreators = _.reduce {
  SET_CURRENT_APPLICATION: 'SET_CURRENT_APPLICATION'
  SET_STICKY_WINDOW: 'SET_STICKY_WINDOW'
  SET_LOG_EVENTS: 'SET_LOG_EVENTS'
  SET_RADIO_SILENCE: 'SET_RADIO_SILENCE'
  SET_UPDATE_AVAILABLE: 'SET_UPDATE_AVAILABLE'
}
, (ac, c) =>
  ac[_.camelCase(c)] = createAction c
  @[c] = c
  exports[c] = c
  ac
, {}

# thunk
actionCreators.installUpdate = ->
  (dispatch, getState) ->
    emit 'installUpdate', true

actionCreators.appStart = ->
  (dispatch, getState) ->
    dispatch {type: '__IMMUTABLE'}

actionCreators.toggleStickyWindow = ->
  (dispatch, getState) ->
    shouldStick = not getState().get 'stickyWindow'
    emit 'toggleStickyWindow',
      id: 'main',
      shouldStick: shouldStick

actionCreators.toggleLogEvents = ->
  (dispatch, getState) ->
    logEvents = not getState().get 'logEvents'
    emit 'logEvents', logEvents

actionCreators.toggleRadioSilence = ->
  (dispatch, getState) ->
    radioSilence = not getState().get 'radioSilence'
    emit 'radioSilence', radioSilence

_.extend actionCreators, changePage: (page = '/') ->
  (dispatch, getState) ->
    dispatch push "/#{page}".replace '//', '/'


module.exports.actionCreators = actionCreators

exports.reducers =
  isImmutable: (state = true) -> state # not a 🐛
  logEvents: (state = developmentMode, {type, payload}) =>
    if type is @SET_LOG_EVENTS then payload else state
  radioSilence: (state = false, {type, payload}) =>
    if type is @SET_RADIO_SILENCE then payload else state
  stickyWindow: (state = false, {type, payload}) =>
    if type is @SET_STICKY_WINDOW then payload.shouldStick else state
  updateAvailable: (state = false, {type, payload}) =>
    if type is @SET_UPDATE_AVAILABLE then payload else state
  currentApplication: (state = '', {type, payload}) =>
    switch type
      when @SET_CURRENT_APPLICATION
        state = payload.name
      else
        state

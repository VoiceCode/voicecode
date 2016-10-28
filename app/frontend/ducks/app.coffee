{createAction} = require 'redux-actions'
{push} = require('react-router-redux')
{currentPageSelector} = require '../selectors'
{setCommandFilter} = require('./command_filter').actionCreators
{setPackageFilter} = require('./package_filter').actionCreators

# 😂
actionCreators = _.reduce {
  SET_CURRENT_APPLICATION: 'SET_CURRENT_APPLICATION'
  SET_STICKY_WINDOW: 'SET_STICKY_WINDOW'
  SET_LOG_EVENTS: 'SET_LOG_EVENTS'
  SET_RADIO_SILENCE: 'SET_RADIO_SILENCE'
  SET_UPDATE_AVAILABLE: 'SET_UPDATE_AVAILABLE'
  SET_RESTART_NEEDED: 'SET_RESTART_NEEDED'
  SET_NETWORK_STATUS: 'SET_NETWORK_STATUS'
}
, (ac, c) =>
  ac[_.camelCase(c)] = createAction c
  @[c] = c
  exports[c] = c
  ac
, {}

# thunk
actionCreators.changePage = (page = '/') ->
    (dispatch, getState) ->
      dispatch push "/#{page}".replace '//', '/'

actionCreators.updateApplication = ->
  (dispatch, getState) ->
    emit 'applicationShouldUpdate', true

actionCreators.appStart = ->
  (dispatch, getState) ->
    dispatch {type: '__IMMUTABLE'}

actionCreators.toggleStickyWindow = ->
  (dispatch, getState) ->
    shouldStick = not getState().get 'sticky_window'
    emit 'toggleStickyWindow',
      id: 'main',
      shouldStick: shouldStick

actionCreators.toggleLogEvents = ->
  (dispatch, getState) ->
    logEvents = not getState().get 'log_events'
    emit 'logEvents', logEvents

actionCreators.setCurrentFilter = ->
  args = arguments
  (dispatch, getState) ->
    currentPage = currentPageSelector getState()
    unless currentPage in ['commands', 'packages']
      dispatch actionCreators.changePage '/commands'

    if currentPage is 'packages'
      dispatch setPackageFilter.apply null, args
    else
      dispatch setCommandFilter.apply null, args

actionCreators.toggleRadioSilence = ->
  (dispatch, getState) ->
    radioSilence = not getState().get 'radio_silence'
    emit 'radioSilence', radioSilence

actionCreators.restartApplication = ->
  (dispatch, getState) ->
    emit 'applicationShouldRestart'

actionCreators.quitApplication = ->
  (dispatch, getState) ->
    emit 'applicationShouldQuit'


module.exports.actionCreators = actionCreators

exports.reducers =
  is_immutable: (state = true) -> state # not a 🐛
  restart_needed: (state = false, {type, payload}) =>
    if type is @SET_RESTART_NEEDED then payload else state
  log_events: (state = developmentMode, {type, payload}) =>
    if type is @SET_LOG_EVENTS then payload else state
  radio_silence: (state = false, {type, payload}) =>
    if type is @SET_RADIO_SILENCE then payload else state
  sticky_window: (state = false, {type, payload}) =>
    if type is @SET_STICKY_WINDOW then payload.shouldStick else state
  update_available: (state = false, {type, payload}) =>
    if type is @SET_UPDATE_AVAILABLE then payload else state
  current_application: (state = '', {type, payload}) =>
    switch type
      when @SET_CURRENT_APPLICATION
        state = payload.name
      else
        state
  network_status: (state = false, {type, payload}) =>
    if type is @SET_NETWORK_STATUS then payload else state

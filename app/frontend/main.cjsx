React = require 'react'
ReactDOM = require 'react-dom'
window.Remote = require('electron').remote
_events = Remote.getGlobal 'Events'
window.emit = _events._emit
window.Events = {on: _events.frontendOn}
{Provider} = require 'react-redux'
{Router, hashHistory} = require 'react-router'
{syncHistoryWithStore} = require 'react-router-redux'
routes = require './routes/main'
Main = require './containers/Main'
window.store = require './stores/main'
history = syncHistoryWithStore hashHistory, store,
  selectLocationState: do ->
    previousRouterState = null
    previousRouterStateJS = null
    (state) ->
      routerState = state.get 'router'
      if previousRouterState isnt routerState
        previousRouterState = routerState
        previousRouterStateJS = routerState.toJS()
      previousRouterStateJS


subscribeToRemoteEvents = ->
  events =
    'apiCreated': 'createApi'
    'packageCreated': 'createPackage'
    'packageUpdated': 'updatePackage'
    'packageRemoved': 'removePackage'
    'commandCreated': 'createCommand'
    'commandEnabled': 'enableCommand'
    'commandDisabled': 'disableCommand'
    'implementationCreated': 'implementationCreated'
    'startupComplete': 'appStart'
    'setPackageFilter': 'setPackageFilter'
    'setCommandFilter': 'setCommandFilter'
    'setCurrentFilter': 'setCurrentFilter'
    'changePage': 'changePage'
    'logger': 'createLogEntry'
    'toggleStickyWindow': 'setStickyWindow'
    'logEvents': 'setLogEvents'
    'radioSilence': 'setRadioSilence'
    'commandSpokenChanged': 'changeSpoken'
    'updateDownloaded': 'setUpdateAvailable'
    'restartNeeded': 'setRestartNeeded'
    'customGrammarCreated': 'createGrammar'
    'customGrammarUpdated': 'updateGrammar'
    'packageSettingsChanged': 'updateSettings'
    'networkStatus': 'setNetworkStatus'
  _.each events, (handler, event) ->
    Events.on event, _.partial _.invoke, store, "actions.#{handler}"

subscribeToRemoteEvents()

Events.on 'packageRequired', ({name}) ->
  new Notification "#{name} is a required package",
    body: "It should not be removed"

Events.on 'updateDownloaded', ({notes, version}) ->
  new Notification "Update is ready to install",
    body: notes

ReactDOM.render(
  <Provider store={store}>
    <Router history={history} routes={routes}/>
  </Provider>
, document.getElementById('root'))

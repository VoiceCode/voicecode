{ createSelector, createSelectorCreator, defaultMemoize } = require 'reselect'
immutable = require 'immutable'

# main window selectors
packageSelector = (state, props) ->
  state.getIn ['packages', props.packageId]

packagesSelector = (state, props) ->
  state.get 'packages'

packageFilterSelector = (state, props) ->
  state.get 'package_filter'

packageFilterQuerySelector = (state, props) ->
  packageFilterSelector(state).get 'query'

packageFilterStateSelector = (state) ->
  packageFilterSelector(state).get 'state'

currentFilterQuerySelector = (state, props) ->
  if props.viewMode is 'commands'
    commandFilterQuerySelector(state, props)
  else
    packageFilterQuerySelector(state, props)

currentFilterStateSelector = (state, props) ->
  if props.viewMode is 'commands'
    state = commandFilterStateSelector(state, props)
    return if state is 'user' then 'user' else 'enabled'
  else
    packageFilterStateSelector(state, props)

commandFilterSelector = (state, props) ->
  state.get 'command_filter'

commandFilterQuerySelector = (state, props) ->
  commandFilterSelector(state).get 'query'

commandFilterStateSelector = (state) ->
  commandFilterSelector(state).get 'state'

commandFilterScopeSelector = (state) ->
  commandFilterSelector(state).get 'scope'

commandsSelector = (state) ->
  state.get 'commands'

commandSelector = (state, props) ->
  commandsSelector(state).get props.commandId

# implementations
implementationsSelector = (state) ->
  state.get 'implementations'
implementationSelector = (state, props) ->
  implementationsSelector(state).get props.id
implementationsForCommand = (state, props) ->
  state.get('command_implementations').get props.commandId

implementationRecordsForCommand =
  createSelector [
    implementationsSelector,
    implementationsForCommand
    ], (implementations, commandImplementations) ->
      commandImplementations.map (id) ->
        implementations.get id


implementationsForPackage = (state, props) ->
  state.get('package_implementations').get props.packageId

viewModeSelector = (state, {viewMode}) -> viewMode

filteredPackagesSelector =
  createSelector [
    viewModeSelector,
    currentFilterQuerySelector,
    currentFilterStateSelector,
    commandFilterScopeSelector,
    packagesSelector
    ], (viewMode, query, state, scope, packages) ->
      if viewMode is 'packages'
        packages = packages.filter (pack) ->
          pack.get('repo')?

      if state in ['enabled', 'disabled']
        packages = packages.filter (pack) ->
          pack.get('installed') is (state is 'enabled')
      if state is 'updatable'
        packages = packages.filter (pack) ->
          pack.get('repoStatus')?.behind
      if state is 'user'
        packages = packages.filter (pack) ->
          pack.get('repo') is null

      scope = 'packages' unless viewMode is 'commands'
      if query isnt '' and scope is 'packages'
        query = new RegExp query, 'i'
        packages = packages.filter (pack) ->
          (query.test pack.get('name')) or
          (query.test pack.get('description'))
      packages

makeCommandsForPackageSelector = ->
  createSelector [
    commandsSelector,
    commandsForPackageSelector
    ], (commands, packageCommands) ->
      packageCommands = packageCommands.map (commandId) ->
        command = commands.get commandId
        command = command.toJS()
        command
      packageCommands.sortBy (command) ->
        command.spoken

commandsForPackageSelector = (state, props) ->
  state.get('package_commands').get props.packageId

makeFilteredCommandsForPackage = ->
  createSelector [
    commandFilterStateSelector,
    _makeFilteredCommandsForPackage()
  ], (state, commands) ->
    unless state in ['all', 'user']
      return commands.filter (command) ->
        command.enabled is (state is 'enabled')
    commands

scopeMap = {
  tags: 'tags'
  commands: 'spoken'
  descriptions: 'description'
}

_makeFilteredCommandsForPackage = ->
  createSelector [
    commandFilterQuerySelector,
    commandFilterScopeSelector
    makeCommandsForPackageSelector(),
  ], (query, scope, commands) ->
    if query isnt '' and scope isnt 'packages'
      query = new RegExp query, 'i'
      scope = scopeMap[scope]
      return commands.filter (command) ->
        if command[scope]?
          subject = command[scope]
          unless _.isString subject
            subject = _.join command[scope], ' '
          query.test subject
    commands

apisForPackage = (state, props) ->
  state.get('package_apis').get props.packageId

showingEventsSelector = (state, props) ->
  state.get('log_events')

radioSilenceSelector = (state, props) ->
  state.get('radio_silence')

updateAvailableSelector = (state, props) ->
  state.get('update_available')

restartNeededSelector = (state) ->
  state.get 'restart_needed'

currentPageSelector = (state) ->
  router = state.get 'router'
  path = router.get('locationBeforeTransitions').get 'pathname'
  path.replace '/', ''

_.assign exports, {
  apisForPackage
  implementationsSelector
  implementationSelector
  implementationsForPackage
  implementationsForCommand
  implementationRecordsForCommand
  commandSelector
  packageSelector
  packagesSelector
  currentPageSelector
  radioSilenceSelector
  showingEventsSelector
  packageFilterSelector
  restartNeededSelector
  commandFilterSelector
  updateAvailableSelector
  filteredPackagesSelector
  commandsForPackageSelector
  makeFilteredCommandsForPackage
}

# history window selectors
currentApplicationSelector = (state) ->
  state.get('current_application')

chainsSelector = (state) ->
  state.get('chains')

activeChainSelector = createSelector currentApplicationSelector, chainsSelector
, (currentApplication, chains) ->
  chains.get currentApplication

_.assign exports, {
  activeChainSelector
}

{ createSelector, createSelectorCreator, defaultMemoize } = require 'reselect'
immutable = require 'immutable'

# main window selectors
packageSelector = (state, props) ->
  state.getIn ['packages', props.packageId]

packagesSelector = (state, {viewMode}) ->
  packages = state.get 'packages'
  packages = packages.sort (a, b) ->
    a.get('name').localeCompare(b.get('name'))
  if viewMode is 'commands'
    packages = packages.filter (pack) ->
      pack.get 'installed'
  packages
packageFilterSelector = (state, props) ->
  state.get 'package_filter'

packageFilterQuerySelector = (state, props) ->
  packageFilterSelector(state).get 'query'
packageFilterStateSelector = (state) ->
  packageFilterSelector(state).get 'state'

currentQuerySelector = (state, props) ->
  if props.viewMode is 'commands'
    commandFilterQuerySelector(state, props)
  else
    packageFilterQuerySelector(state, props)

filteredPackagesSelector = createSelector [
  currentQuerySelector,
  packageFilterStateSelector,
  packagesSelector,
  ], (query, state, packages) ->
    unless state is 'all'
      packages = packages.filter (pack) ->
        pack.get('installed') is (state is 'enabled')
    if query isnt ''
      query = new RegExp query, 'gi'
      packages = packages.filter (pack) ->
        query.test pack.get('name')
    packages


commandFilterSelector = (state, props) ->
  state.get 'command_filter'

commandFilterQuerySelector = (state, props) ->
  commandFilterSelector(state).get 'query'
commandFilterStateSelector = (state) ->
  commandFilterSelector(state).get 'state'
commandFilterScopeSelector = (state) ->
  commandFilterSelector(state).get 'scope'

filteredCommandsSelector = createSelector [
  packagesSelector,
  commandFilterQuerySelector,
  commandFilterScopeSelector
  ], (packages, query, scope) ->
    if query isnt '' and scope is 'packages'
      query = new RegExp query, 'gi'
      packages = packages.filter (pack) ->
        query.test pack.get('name')
    packages

commandsSelector = (state) ->
  state.get 'commands'

commandSelector = (state, props) ->
  commandsSelector(state).get props.commandId

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
    unless state is 'all'
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
    packageFilterQuerySelector,
    commandFilterScopeSelector
    makeCommandsForPackageSelector(),
  ], (query, scope, commands) ->
    if query isnt '' and scope isnt 'packages'
      query = new RegExp query, 'gi'
      scope = scopeMap[scope]
      commands = commands.filter (command) ->
        if command[scope]?
          subject = command[scope]
          unless _.isString subject
            subject = _.join command[scope], ' '
          query.test subject
    commands

apisForPackage = (state, props) ->
  state.get('package_apis').get props.packageId

implementationsForCommand = (state, props) ->
  state.get('command_implementations').get props.commandId

showingEventsSelector = (state, props) ->
  state.get('logEvents')
radioSilenceSelector = (state, props) ->
  state.get('radioSilence')
updateAvailableSelector = (state, props) ->
  state.get('updateAvailable')

_.assign exports, {
  apisForPackage
  commandSelector
  packageSelector
  packagesSelector
  radioSilenceSelector
  showingEventsSelector
  packageFilterSelector
  commandFilterSelector
  updateAvailableSelector
  filteredPackagesSelector
  commandsForPackageSelector
  implementationsForCommand
  makeFilteredCommandsForPackage
}

# history window selectors
currentApplicationSelector = (state) ->
  state.get('currentApplication')

chainsSelector = (state) ->
  state.get('chains')

activeChainSelector = createSelector currentApplicationSelector, chainsSelector
, (currentApplication, chains) ->
  chains.get currentApplication


_.assign exports, {
  activeChainSelector
}

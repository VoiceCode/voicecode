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
packageFilterScopeSelector = (state) ->
  packageFilterSelector(state).get 'scope'

filteredPackagesSelector = createSelector [
  packagesSelector,
  packageFilterQuerySelector,
  packageFilterScopeSelector
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
    packageFilterStateSelector,
    _makeFilteredCommandsForPackage()
  ], (state, commands) ->
    console.log 'filtering state'
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
    packageFilterScopeSelector
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

_.assign exports, {
  apisForPackage
  commandSelector
  packageSelector
  packagesSelector
  showingEventsSelector
  packageFilterSelector
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

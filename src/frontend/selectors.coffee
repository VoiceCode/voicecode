{ createSelector, createSelectorCreator, defaultMemoize } = require 'reselect'
immutable = require 'immutable'

# main window selectors
packageSelector = (state, props) ->
  state.getIn ['packages', props.packageId]

packagesSelector = (state, props) ->
  state.get 'packages'

packageFilterSelector = (state, props) ->
  state.get 'package_filter'

filteredPackagesSelector = createSelector [
  packagesSelector,
  packageFilterSelector
  ], (packages, filter) ->
    {query, scope} = filter.toJS()
    if query isnt '' and scope is 'packages'
      packages = packages.filter (pack) ->
        pack.get('name').indexOf(query) isnt -1
    packages.sortBy (pack) -> pack.get 'name'

commandsSelector = (state) ->
  state.get 'commands'

commandSelector = (state, props) ->
  commandsSelector(state).get props.commandId

commandsForPackageSelector = (state, props) ->
  state.get('package_commands').get props.packageId

packageFilterQuerySelector = (state, props) ->
  packageFilterSelector(state).get 'query'

# here "state" is filtering by enabled/disabled state
packageFilterStateSelector = (state) ->
  packageFilterSelector(state).get 'state'

makeFilteredCommandsForPackage = ->
  createSelector [
    packageFilterStateSelector,
    _makeFilteredCommandsForPackage()
  ], (filter, commands) ->
    console.log 'filtering state'
    unless filter is 'all'
      return commands.filter (command) ->
        command.enabled is (filter is 'enabled')
    commands
_makeFilteredCommandsForPackage = ->
  createSelector [
    commandsForPackageSelector,
    packageFilterQuerySelector,
  ], (commands, query) ->
    if query isnt ''
      console.log 'filtering query'
      commands = commands.filter (command) ->
        {id, spoken} = command
        if spoken?
          spoken = spoken.indexOf(query) isnt -1
        id = id.indexOf(query) isnt -1
        spoken or id
    console.log 'sorting'
    commands.sortBy (command) -> command.spoken

apisForPackage = (state, props) ->
  state.get('package_apis').get props.packageId

implementationsForCommand = (state, props) ->
  state.get('command_implementations').get props.commandId

_.assign exports, {
  apisForPackage
  commandSelector
  packageSelector
  packagesSelector
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

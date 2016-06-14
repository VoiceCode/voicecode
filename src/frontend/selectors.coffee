{ createSelector } = require 'reselect'
immutable = require 'immutable'

# main window selectors
packagesSelector = (state, props) ->
  state.get 'packages'

packageFilterSelector = (state, props) ->
  state.get 'package_filter'

filteredPackagesSelector = createSelector [
  packagesSelector,
  packageFilterSelector
  ], (packages, filter) ->
    filter = filter.toJS()
    if filter.query isnt '' and filter.scope is 'packages'
      packages = packages.filter (pack) ->
        pack.get('name').indexOf(filter.query) isnt -1
    packages.sortBy (pack) -> pack.get 'name'

commandsSelector = (state, props) ->
  state.get 'commands'

commandSelector = (state, props) ->
  commandsSelector(state).get props.commandId

commandsForPackage = (state, props) ->
  state.get('package_commands').get props.packageId

apisForPackage = (state, props) ->
  state.get('package_apis').get props.packageId

implementationsForCommand = (state, props) ->
  state.get('command_implementations').get props.commandId

_.assign exports, {
  apisForPackage
  commandSelector
  packagesSelector
  commandsForPackage
  packageFilterSelector
  filteredPackagesSelector
  implementationsForCommand
}


# history window selectors
currentApplicationSelector = (state) ->
  state.get('currentApplication')

chainsSelector = (state) ->
  state.get('chains')

activeChainSelector = createSelector currentApplicationSelector, chainsSelector
, (currentApplication, chains) ->
  console.debug arguments
  chains.get currentApplication


_.assign exports, {
  activeChainSelector
}

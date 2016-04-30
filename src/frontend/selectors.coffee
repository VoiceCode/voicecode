{ createSelector } = require 'reselect'
immutable = require 'immutable'

# main window selectors
_packagesSelector = (state, props) ->
  state.get 'packages'
packagesSelector = createSelector [_packagesSelector], (packages) ->
  packages.sortBy (pack) -> pack.get 'name'

commandsSelector = (state, props) -> state.get 'commands'

commandSelector = (state, props) ->
  commandsSelector(state).get props.commandId

commandsForPackage = (state, props) ->
  state.get('package_commands').get props.packageId

implementationsForCommand = (state, props) ->
  state.get('command_implementations').get props.commandId

_.assign exports, {
  packagesSelector
  commandsForPackage
  commandSelector
  implementationsForCommand

}


# history window selectors
currentApplicationSelector = (state) ->
  state.get('currentApplication')
chainsSelector = (state) -> state.get('chains')
activeChainSelector = createSelector currentApplicationSelector, chainsSelector
, (currentApplication, chains) ->
  console.debug arguments
  chains.get currentApplication



_.assign exports, {
  activeChainSelector
}

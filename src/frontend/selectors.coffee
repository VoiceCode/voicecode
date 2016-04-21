{ createSelector } = require 'reselect'

_packagesSelector = (state, props) ->
  state.get 'packages'
packagesSelector = createSelector [_packagesSelector], (packages) ->
  packages.sortBy (pack) -> pack.get 'name'

commandsSelector = (state, props) -> state.get 'commands'
commandSelector = (state, props) ->
  commandsSelector(state).get props.commandId

commandsForPackage = (state, props) ->
  state.get('package_commands').get props.packageId


_.extend exports, {
  packagesSelector
  commandsForPackage
  commandSelector
}

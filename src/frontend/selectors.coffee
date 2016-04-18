{ schema } = require './models'
{ createSelector } = require 'reselect'

exports.ormSelector = ormSelector = (state) -> state.orm


exports.commands = createSelector ormSelector, schema.createSelector (orm) ->
  orm.Command.all().toRefArray()

exports.packages = createSelector ormSelector, schema.createSelector (orm) ->
  orm.Package.all().map (Package) ->
    result = _.assign {}, Package.ref
    result.commands = Package.commands.withRefs.map (command) -> command
    result

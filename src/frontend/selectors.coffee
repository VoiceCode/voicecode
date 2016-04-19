{ schema } = require './models'
{ createSelector } = require 'reselect'

exports.ormSelector = ormSelector = (state) -> state.orm


exports.commands = createSelector ormSelector, schema.createSelector (orm) ->
  orm.Command.all().map (Command) ->
    result = _.assign {}, Command.ref
    result.implementations = Command.implementations.toRefArray()
    result

exports.packages = createSelector ormSelector, schema.createSelector (orm) ->
  orm.Package.all().map (Package) ->
    result = _.assign {}, Package.ref
    result.commands = Package.commands.map (Command) ->
      command = _.assign {}, Command.ref
      command.implementations = Command.implementations.withRefs.all().map (imp) ->
        imp.packageId
      command
    result

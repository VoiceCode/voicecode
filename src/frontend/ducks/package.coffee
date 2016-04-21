{ createAction } = require 'redux-actions'
immutable = require 'immutable'
{CREATE_COMMAND} = require('./command')

constants =
  CREATE_PACKAGE: 'CREATE_PACKAGE'
  UPDATE_PACKAGE: 'UPDATE_PACKAGE'

_.extend @, constants
_.extend exports, constants

exports.actionCreators =
  createPackage: createAction @CREATE_PACKAGE
  updatePackage: createAction @UPDATE_PACKAGE

packageRecord = immutable.Record
  name: 'unknown'
  description: 'no description'

exports.reducers =
  packages: (packages = immutable.Map({}), {type, payload}) =>
    switch type
      when @CREATE_PACKAGE
        pack = new packageRecord _.pick(payload, ['name', 'description'])
        packages.set payload.name, pack
      when @UPDATE_PACKAGE
        packages.mergeDeepIn [payload.name], payload
      else
        packages
  package_commands: (package_commands = immutable.Map({}), {type, payload}) =>
    switch type
      when @CREATE_PACKAGE
        package_commands.set payload.name, immutable.Set []
      when CREATE_COMMAND
        package_commands.mergeIn [payload.packageId], [payload.id]
      else
        package_commands

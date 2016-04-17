{Model, Schema, fk, many, oneToOne} = require 'redux-orm'
{ CREATE_COMMAND, ENABLE_COMMAND, DISABLE_COMMAND } = require './ducks/command.coffee'
{ CREATE_PACKAGE } = require './ducks/package.coffee'
#FML, extending babel/browserify/ES6 classes and CoffeeScript doesn't work
`
class Package extends Model {
  static reducer(packages, action, Package, session) {
    const {type, payload} = action
      switch (type) {
        case CREATE_PACKAGE:
          Package.create(_.pick(payload, ['name', 'description']))
          break
      return Package.getNextState()}
  }
}
Package.modelName = 'Package'
Package.backend = {
  idAttribute: 'name'
}

class Command extends Model {
  static reducer(commands, action, Command, session) {
    const {type, payload} = action
    switch (type) {
      case CREATE_COMMAND:
        const command = _.pick(payload, ['id', 'spoken', 'enabled', 'packageId'])
        Command.create(command)
        break
      case ENABLE_COMMAND:
        Command.withId(payload).set('enabled', true)
        break
      case DISABLE_COMMAND:
        Command.withId(payload).set('enabled', false)
        break
    return Command.getNextState()}
  }
}
Command.modelName = 'Command'
Command.fields = {
  packageId: fk('Package', 'commands')
}


`
# class Implementation extends Model
#   @modelName: 'Implementation Model'
#   @fields: {
#     command: foreignKey 'Command', 'implementations'
#     package: foreignKey 'Implementation', 'implementations'
#   }
#
# class Setting extends Model
#   @modelName: 'Setting Model'
#   @fields: {
#     package: foreignKey 'Package', 'settings'
#   }
#
# class Action extends Model
#   @modelName: 'Action Model'
#   @fields: {
#     package: foreignKey 'Package', 'actions'
#   }
#
# class Before extends Model
#   @modelName: 'Before Model'
#   @fields: {
#     command: foreignKey 'Command', 'befores'
#     package: foreignKey 'Package', 'befores'
#   }
#
# class After extends Model
#   @modelName: 'After Model'
#   @fields: {
#     command: foreignKey 'Command', 'afters'
#     package: foreignKey 'Package', 'afters'
#   }
#
# class Scope extends Model
#   @modelName: 'Scope Model'
#   @fields: {
#     package: oneToOne 'Package', 'scope'
#   }
schema = new Schema()
schema.register Command, Package

module.exports = {
  Package,
  Command,
  # Implementation,
  # Setting,
  # Action,
  # Before,
  # After,
  # Scope
  schema
}

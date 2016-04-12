{Model, Schema, fk: foreignKey, many, oneToOne} = require 'redux-orm'
class Package extends Model
  @modelName: 'Package Model'
  @backend: {
    idAttribute: 'name'
  }

class Command extends Model
  @modelName: 'Command Model'
  @fields: {
    package: foreignKey 'Package', 'commands'
  }

class Implementation extends Model
  @modelName: 'Implementation Model'
  @fields: {
    command: foreignKey 'Command', 'implementations'
    package: foreignKey 'Implementation', 'implementations'
  }

# class Setting extends Model
#   @modelName: 'Setting Model'
#   @fields: {
#     package: foreignKey 'Package', 'settings'
#   }

class Action extends Model
  @modelName: 'Action Model'
  @fields: {
    package: foreignKey 'Package', 'actions'
  }

class Before extends Model
  @modelName: 'Before Model'
  @fields: {
    command: foreignKey 'Command', 'befores'
    package: foreignKey 'Package', 'befores'
  }

class After extends Model
  @modelName: 'After Model'
  @fields: {
    command: foreignKey 'Command', 'afters'
    package: foreignKey 'Package', 'afters'
  }

# class Scope extends Model
#   @modelName: 'Scope Model'
#   @fields: {
#     package: oneToOne 'Package', 'scope'
#   }

module.exports = {
  Package,
  Command,
  Implementation,
  # Setting,
  Action,
  Before,
  After,
  # Scope
}

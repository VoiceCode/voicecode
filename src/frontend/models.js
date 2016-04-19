// FML, extending babel/browserify/ES6(?) classes with CoffeeScript doesn't work
const requireDirectory = require('require-directory')
const {Model, Schema, fk, many, oneToOne} = require('redux-orm')
const ducks = requireDirectory(module, './ducks/')
var reducers = _.reduce(ducks, (reducers, duck, id) => {
  reducers[id] = duck.reducer
  return reducers
}, {})

class Package extends Model {}
Package.reducer = reducers.package
Package.modelName = 'Package'
Package.backend = {
  idAttribute: 'name'
}

class Command extends Model {}
Command.reducer = reducers.command
Command.modelName = 'Command'
Command.fields = {
  packageId: fk('Package', 'commands')
}

class Implementation extends Model {}
Implementation.reducer = reducers.implementation
Implementation.modelName = 'Implementation'
Implementation.fields = {
  packageId: fk('Package', 'implementations'),
  commandId: fk('Command', 'implementations')
}


schema = new Schema()
schema.register(Command, Package, Implementation)

module.exports = {
  Package,
  Command,
  Implementation,
  schema
}

{ createAction } = require 'redux-actions'
immutable = require 'immutable'
constants =
  CREATE_PACKAGE: 'CREATE_PACKAGE'
_.extend @, constants
_.extend exports, constants

exports.actionCreators =
  createPackage: createAction(@CREATE_PACKAGE)

exports.reducer = (packages, {type, payload}, Package, session) =>
  switch type
    when @CREATE_PACKAGE
      Package.create(_.pick(payload, ['name', 'description']))
  Package.getNextState()

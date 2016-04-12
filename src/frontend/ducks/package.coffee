{ createAction } = require 'redux-actions'
immutable = require 'immutable'
exports.CREATE_PACKAGE = CREATE_PACKAGE = 'CREATE_PACKAGE'
{ CREATE_COMMAND } = require './command.coffee'

exports.actionCreators =
  createPackage: createAction(CREATE_PACKAGE)

exports.reducer = (packages = {}, {type, payload}) ->
  switch type
    when CREATE_COMMAND
      packages.updateIn [payload.packageId, 'commands'], (commands) ->
        commands.push payload.id
    when CREATE_PACKAGE
      packages.update payload.name, -> immutable.fromJS
        name: payload.name
        description: payload.description
        commands: {}
    else
      packages

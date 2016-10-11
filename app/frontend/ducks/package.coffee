{ createAction } = require 'redux-actions'
immutable = require 'immutable'
{CREATE_COMMAND} = require('./command')
{CREATE_API} = require './api'
constants =
  CREATE_PACKAGE: 'CREATE_PACKAGE'
  UPDATE_PACKAGE: 'UPDATE_PACKAGE'

_.extend @, constants
_.extend exports, constants

exports.actionCreators =
  createPackage: createAction @CREATE_PACKAGE
  updatePackage: createAction @UPDATE_PACKAGE
  installPackage: (name) ->
    (dispatch, getState) ->
      emit 'installPackage', name
  removePackage: (name) ->
    (dispatch, getState) ->
      emit 'removePackage', name
  revealPackageSource: (name) ->
    (dispatch, getState) ->
      emit 'commandsShouldExecute', [{
        command: 'os:revealDirectory',
        'arguments': "~/voicecode/packages/#{name}"
        }]
  revealPackageOrigin: (name) ->
    (dispatch, getState) ->
      repo = getState().get('packages').get(name).get('repo')
      emit 'commandsShouldExecute', [{
        command: 'os:openURL',
        'arguments': repo
        }]

packageRecord = immutable.Record
  name: 'unknown'
  description: 'No description'
  installed: false
  repo: ''

apiRecord = immutable.Record
  name: null
  description: null
  signature: null
  shorthandFor: null

exports.reducers =
  packages: (packages = immutable.Map({}), {type, payload}) =>
    switch type
      when @CREATE_PACKAGE
        pack = new packageRecord payload
        packages.set payload.name, pack
      when @UPDATE_PACKAGE
        packages.mergeDeepIn [payload.name], payload
      else
        packages
  package_commands: (package_commands = immutable.Map({}), {type, payload}) =>
    switch type
      when @CREATE_PACKAGE
        package_commands.set payload.name, immutable.List []
      when CREATE_COMMAND
        {id, spoken, packageId, enabled} = payload
        package_commands.updateIn [packageId]
        , (list) -> list.push id
      else
        package_commands
  package_apis: (package_apis = immutable.Map({}), {type, payload}) =>
    switch type
      when @CREATE_PACKAGE
        package_apis.set payload.name, immutable.List []
      when CREATE_API
        package_apis.updateIn [payload.packageId],
        (list) ->
          list.push new apiRecord payload.api
      else
        package_apis

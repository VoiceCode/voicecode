{ createAction } = require 'redux-actions'
immutable = require 'immutable'
{CREATE_COMMAND} = require('./command')
{CREATE_IMPLEMENTATION} = require './implementation'
{CREATE_API} = require './api'
constants =
  CREATE_PACKAGE: 'CREATE_PACKAGE'
  UPDATE_PACKAGE: 'UPDATE_PACKAGE'
  REMOVE_PACKAGE: 'REMOVE_PACKAGE'

_.extend @, constants
_.extend exports, constants

exports.actionCreators =
  createPackage: createAction @CREATE_PACKAGE
  updatePackage: createAction @UPDATE_PACKAGE
  removePackage: createAction @REMOVE_PACKAGE
  shouldInstallPackage: (name, event) ->
    # event.target.classList.add 'disabled'
    (dispatch, getState) ->
      emit 'installPackage', name
  shouldRemovePackage: (name) ->
    (dispatch, getState) ->
      emit 'removePackage', name
  shouldUpdatePackage: (name) ->
    (dispatch, getState) ->
      emit 'updatePackage', name
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
  repo: null
  repoStatus: {behind: false, diverged: false}
  repoLog: []
apiRecord = immutable.Record
  name: null
  description: null
  signature: null
  shorthandFor: null

exports.reducers =
  packages: (packages = immutable.Map({}), {type, payload}) =>
    switch type
      when @CREATE_PACKAGE, @UPDATE_PACKAGE
        payload = payload.pack
        payload = payload.options
        pack = new packageRecord payload
        packages = packages.set payload.name, pack
        packages.sort (a, b) ->
          a.get('name').localeCompare(b.get('name'))
      when @REMOVE_PACKAGE
        packages.updateIn [payload]
        , (pack) -> pack.set 'installed', false
      else
        packages
  package_commands: (package_commands = immutable.Map({}), {type, payload}) =>
    switch type
      when @CREATE_PACKAGE
        payload = payload.pack
        package_commands.set payload.name, immutable.List []
      when CREATE_COMMAND
        {id, spoken, packageId, enabled} = payload
        package_commands.updateIn [packageId]
        , (list) -> list.push id
      else
        package_commands
  package_implementations: (package_implementations = immutable.Map({}), {type, payload}) =>
    switch type
      when @CREATE_PACKAGE
        payload = payload.pack
        package_implementations.set payload.name, immutable.List []
      when CREATE_IMPLEMENTATION
        {originalPackageId, packageId, id} = payload
        # only keep track of packages that implement commands from another package
        if originalPackageId isnt packageId
          package_implementations.updateIn [packageId]
          , (list) -> list.push id
        else
          package_implementations
      else
        package_implementations
  package_apis: (package_apis = immutable.Map({}), {type, payload}) =>
    switch type
      when @CREATE_PACKAGE
        payload = payload.pack
        package_apis.set payload.name, immutable.List []
      when CREATE_API
        package_apis.updateIn [payload.packageId],
        (list) ->
          list.push new apiRecord payload.api
      else
        package_apis

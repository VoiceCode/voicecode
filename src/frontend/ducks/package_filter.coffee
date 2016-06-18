{createAction} = require 'redux-actions'
immutable = require 'immutable'
constants =
  SET_PACKAGE_FILTER: 'SET_PACKAGE_FILTER'
  SET_PACKAGE_FILTER_SCOPE: 'SET_PACKAGE_FILTER_SCOPE'
_.extend @, constants
_.extend exports, constants

actionCreators =
  setPackageFilter: createAction(@SET_PACKAGE_FILTER)
exports.actionCreators = actionCreators


defaultState = immutable.Map
  scope: 'packages'
  query: ''
  focused: false
  state: 'all'
scopes =
  descriptions: new RegExp /^descriptions*:|^d:\W*/
  commands: new RegExp /^commands*:|^c:\W*/
  packages: new RegExp /^packages*:|^p:\W*/
  tags: new RegExp /^tags*:|^t:\W*/

exports.reducers =
  package_filter: (pf = defaultState, {type, payload}) =>
    switch (type)
      when @SET_PACKAGE_FILTER
        {focused, query, scope, state} = payload
        if not scope? and query?
          _.each scopes, (expression, scope) ->
            if expression.test query
              pf = pf.set 'scope', scope
              query = query.replace(expression, '')
              return false
            return true
        pf = pf.set 'scope', scope if scope?
        pf = pf.set 'query', query if query?
        pf = pf.set 'focused', focused if focused?
        pf = pf.set 'state', state if state?
        pf
      else
        pf

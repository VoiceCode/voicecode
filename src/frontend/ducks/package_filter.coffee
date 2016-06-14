{createAction} = require 'redux-actions'
immutable = require 'immutable'
constants =
  SET_PACKAGE_FILTER: 'SET_PACKAGE_FILTER'
  CLEAR_PACKAGE_FILTER_SCOPE: 'CLEAR_PACKAGE_FILTER_SCOPE'
_.extend @, constants
_.extend exports, constants

actionCreators =
  setPackageFilter: createAction(@SET_PACKAGE_FILTER)
  clearPackageFiltersScope: createAction(@CLEAR_PACKAGE_FILTER_SCOPE)
exports.actionCreators = actionCreators

# # thunk
actionCreators.focusPackageFilter = (query) ->
  (dispatch, getState) ->
    state = getState()
    state = state.get('package_filter').toJS()
    state.focused = true
    dispatch actionCreators.setPackageFilter state


defaultState = immutable.Map({scope: 'packages', query: ''})
exports.reducers =
  package_filter: (pf = defaultState, {type, payload}) =>
    switch (type)
      when @SET_PACKAGE_FILTER
        {focused, query} = payload
        packagesScope = new RegExp /^packages*:|^p:/
        tagsScope = new RegExp /^tags*:|^t:/
        if packagesScope.test query
          pf.set 'scope', 'packages'
        if tagsScope.test query
          pf.set 'scope', 'tags'
        query = query.replace(packagesScope, '')
        query = query.replace(tagsScope, '')
        pf = pf.set 'query', query
        pf = pf.set 'focused', focused
      else
        pf

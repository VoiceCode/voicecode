{ createAction } = require 'redux-actions'

# 😂
# exports.actionCreators = _.reduce {
#     APP_INIT_START: 'APP_INIT_START'
#     APP_INIT_FINISH: 'APP_INIT_FINISH'
# }
# , (ac, c) =>
#   ac[_.camelCase(c)] = createAction c
#   @[c] = c
#   exports[c] = c
# , {}

# thunk
exports.actionCreators =
  appStart: ->
    (dispatch, getState) ->
      dispatch {type: '__IMMUTABLE'}


# exports.reducers =
#   implementations: (implementations = immutable.Map({}), {type, payload}) =>
#     switch type
#       else
#         implementations

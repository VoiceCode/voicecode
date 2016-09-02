{ createAction } = require 'redux-actions'

exports.stuffThisDuck = (duck, module) ->
  if duck.constants?
    duck.actionCreators = _.extend (duck.actionCreators or {})
    , _.reduce duck.constants, (ac, c) ->
      duck[c] = c
      module.exports[c] = c
      ac[_.camelCase(c)] = createAction c
      ac
    , {}

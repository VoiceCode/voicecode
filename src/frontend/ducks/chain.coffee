immutable = require 'immutable'
{createAction} = require 'redux-actions'
constants =
  CREATE_CHAIN: 'CREATE_CHAIN'
  CREATE_CHAIN_LINK: 'CREATE_CHAIN_LINK'

_.extend @, constants
_.extend exports, constants

actionCreators =
  createChain: createAction(@CREATE_CHAIN)
  createChainLink: createAction(@CREATE_CHAIN_LINK)

# # thunk
# actionCreators.toggleCommand = (id, enabled) ->
#   (dispatch, getState) ->
#     if enabled
#       emit 'enableCommand', id
#     else
#       emit 'disableCommand', id

exports.actionCreators = actionCreators

exports.reducers =
  chains: (chains = immutable.Map({}), {type, payload}) =>
    switch (type)
      when @CREATE_CHAIN
        chains.updateIn [payload.context], (chains) ->
          if not chains?
            chains = immutable.List []
          chains = chains.insert 0, immutable.List []
          if chains.size is 6
            chains = chains.pop()
          chains

      when @CREATE_CHAIN_LINK
        chains.updateIn [payload.context, 0], (chain) ->
          chain.unshift payload.command
      else
        chains

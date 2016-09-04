React = require 'react'

{ connect } = require 'react-redux'
{ activeChainSelector } = require '../selectors'
stateToProps = (state) ->
  chains: activeChainSelector state


class ChainList extends React.Component
  render: ->
    {chains} = @props
    return null if not chains
    <div className="">
    {
      chains.map (chain, chaIndex) ->
        <div key={chaIndex} className='ui inverted black segment'>
            <div className="ui floating yellow label">
              <strong className="history-index">{chaIndex + 1}</strong>
            </div>
          {
            chain.map ({command, 'arguments': args}, comIndex) ->
              <div key={comIndex} className=''>
              {command}
              { unless args is null then JSON.stringify(args) }
              </div>
          }
        </div>
    }
    </div>

module.exports = connect(stateToProps)(ChainList)

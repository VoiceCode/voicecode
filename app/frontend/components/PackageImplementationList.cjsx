React = require 'react'
PackageImplementation = require '../components/PackageImplementation.cjsx'
{connect} = require 'react-redux'
{implementationsForPackage} = require '../selectors'

makeMapStateToProps = (state, props) ->
  implementations: implementationsForPackage state, props

class PackageImplementationList extends React.Component
  shouldComponentUpdate: (nextProps, nextState) ->
    @props.implementations isnt nextProps.implementations

  render: ->
    {implementations} = @props
    return null unless implementations.size
    <div className="ui segment">
      <div className="ui top left attached label">
        { implementations.size }
        { if implementations.size is 1 then ' command implementation' else ' command implementations' }
      </div>
      { if implementations.size
          <div className="ui relaxed divided list">
          {
            implementations.map (id, index) ->
              <PackageImplementation key={ index } id={ id } />
          }
          </div>
      }
    </div>


module.exports = connect(makeMapStateToProps)(PackageImplementationList)

React = require 'react'
Command = require '../components/Command.cjsx'
Api = require '../components/Api.cjsx'
{connect} = require 'react-redux'
{apisForPackage} = require '../selectors'
makeMapStateToProps = (state, props) ->
    apis: apisForPackage state, props


ApiList = class ApiList extends React.Component
  shouldComponentUpdate: (nextProps, nextState) ->
    @props.apis isnt nextProps.apis

  render: ->
    console.info "rendering api list"
    {apis} = @props
    return null unless apis?
    <div className="ui segment">
      <div className="ui top left attached label">
        { apis.size }
        { if apis.size is 1 then ' api' else ' apis' }
      </div>
      { if apis.size
          <div className="ui relaxed divided list">
          {
            apis.map (api, index) ->
              <Api key={ index } api={ api } />
          }
          </div>
      }
    </div>


module.exports = connect(makeMapStateToProps)(ApiList)

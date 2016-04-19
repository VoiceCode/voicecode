React = require 'react'
{ connect } = require 'react-redux'
{toggleCommand} = require('../ducks/command').actionCreators
PureRenderMixin = require('react-addons-pure-render-mixin')

mapDispatchToProps = {
  toggleCommand
}
class Command extends React.Component
  mixins: [PureRenderMixin]

  render: ->
    {testicle, toggleCommand} = @props
    {id, spoken, enabled, packageId, implementations} = @props
    console.warn "RENDERING COMMAND: #{id}"
    <div className="item">
      <div className="ui fitted checkbox">
        <input
        type="checkbox"
        checked={ enabled }
        onChange={ (event) ->
          toggleCommand id, event.target.checked }/>
        <label></label>
      </div>

      <div className="content">
        <div className="header">{ spoken }</div>
        <div className="meta">{ id }</div>
        {
          _.map implementations, (imp) ->
            <a className="ui mini gray label" key={ imp.id }>{ imp.packageId }</a>
        }
      </div>
    </div>

module.exports = connect(null, mapDispatchToProps)(Command)

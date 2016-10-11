React = require 'react'
{connect} = require 'react-redux'
{
  updateAvailableSelector,
  restartNeededSelector,
} = require '../selectors'
{
  updateApplication,
  restartApplication,
  quitApplication
} = require('../ducks/app').actionCreators

mapDispatchToProps = {
  updateApplication,
  restartApplication,
  quitApplication
}
mapStateToProps = (state, props) ->
  restartNeeded: restartNeededSelector state
  updateAvailable: updateAvailableSelector state

class Footer extends React.Component
  render: ->
    {
      restartNeeded,
      updateAvailable,
      quitApplication
      updateApplication,
      restartApplication,
    } = @props
    <div className='footer ui bottom fixed mini inverted menu'>
      <a className='item inverted' title="click to quit VoiceCode.app"
           onClick={ quitApplication } >
           <i className="power icon"></i>
      </a>
      <a className='item inverted' title="click to restart VoiceCode.app"
           onClick={ restartApplication } >
           <i className="refresh up icon"></i>
      </a>

      <div className='right menu'>
        {
          if updateAvailable
              <a className='item inverted yellow' title="click to update VoiceCode.app"
                   onClick={ updateApplication } >
                   <i className="yellow arrow circle up icon"></i>
              UPDATE </a>
        } {
          if restartNeeded
              <a className='item inverted red' title="click to restart VoiceCode.app"
                   onClick={ restartApplication } >
                   <i className="yellow arrow circle up icon"></i>
              UPDATE </a>
        }
        <div className='item'>
          <div className="appVersion" >v { Remote.getGlobal('appVersion') }</div>
        </div>
      </div>
    </div>
module.exports = connect(mapStateToProps, mapDispatchToProps) Footer

React = require 'react'
classNames = require 'classnames'
{connect} = require 'react-redux'
{
  updateAvailableSelector,
  restartNeededSelector,
  networkStatusSelector
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
  online: networkStatusSelector state

class Footer extends React.Component
  render: ->
    {
      online,
      restartNeeded,
      updateAvailable,
      quitApplication,
      updateApplication,
      restartApplication,
    } = @props
    networkStatusClasses = classNames
      icon: true
      green: online
      red: !online
      circle: true
      tiny: true
    restartIconClasses = classNames
      "icon": true
      "refresh": true
      "inverted": true
    restartItemClasses = classNames
      "item": true
    <div className='footer ui bottom fixed mini inverted icon menu'>
      <a className={ restartItemClasses }
         title="quit VoiceCode"
         onClick={ quitApplication } >
           <i className="power icon"></i>
      </a>
      <a className='item '
         title="restart VoiceCode"
         onClick={ restartApplication } >
           <i className={ restartIconClasses }></i>
           {
             if restartNeeded
              "RESTART NEEDED"
           }
      </a>

      <div className='right menu'>
        {
          if updateAvailable
              <a className='item '
                 title="update VoiceCode"
                 onClick={ updateApplication } >
                   <i className="yellow arrow circle up icon"></i>
                   {"UPDATE to #{updateAvailable.version}"}
              </a>
        }
        <div className='item'>
          <i className={ networkStatusClasses }></i>
          <div className="appVersion" >v { Remote.getGlobal('appVersion') }</div>
        </div>
      </div>
    </div>
module.exports = connect(mapStateToProps, mapDispatchToProps) Footer

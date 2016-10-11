React = require 'react'
classNames = require 'classnames'
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
      quitApplication,
      updateApplication,
      restartApplication,
    } = @props
    restartIconClasses = classNames
      "icon": true
      "refresh": true
      "inverted": true
    restartItemClasses = classNames
      "item": true
    <div className='footer ui bottom fixed mini inverted icon menu'>
      <a className={ restartItemClasses }
         title="quit VoiceCode.app"
         onClick={ quitApplication } >
           <i className="power icon"></i>
      </a>
      <a className='item '
         title="restart VoiceCode.app"
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
                 title="update VoiceCode.app"
                 onClick={ updateApplication } >
                   <i className="yellow arrow circle up icon"></i>
                   UPDATE
              </a>
        }
        <div className='item'>
          <div className="appVersion" >v { Remote.getGlobal('appVersion') }</div>
        </div>
      </div>
    </div>
module.exports = connect(mapStateToProps, mapDispatchToProps) Footer

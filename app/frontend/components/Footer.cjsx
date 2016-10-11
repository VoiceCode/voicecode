React = require 'react'
{connect} = require 'react-redux'
{updateAvailableSelector} = require '../selectors'
{installUpdate} = require('../ducks/app').actionCreators

mapDispatchToProps = {installUpdate}
mapStateToProps = (state, props) ->
  updateAvailable: updateAvailableSelector state

class Footer extends React.Component
  render: ->
    {updateAvailable, installUpdate} = @props
    <div className='footer ui bottom fixed mini inverted menu'>
      <div className='right menu'>
        {
          if updateAvailable
              <a className='item inverted yellow'
                   onClick={ installUpdate } >
                   <i className="yellow arrow circle up icon"></i>
              UPDATE </a>
        }
        <div className='item'>
          <div className="appVersion" >v { Remote.getGlobal('appVersion') }</div>
        </div>
      </div>
    </div>
module.exports = connect(mapStateToProps, mapDispatchToProps) Footer

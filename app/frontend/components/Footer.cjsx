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
        <div className='item'>
          {
            if updateAvailable
              <div className='item'>
                <div className='ui inverted yellow button'
                     onClick={ installUpdate }
                >UPDATE</div>
              </div>
          }
          <div className="appVersion" >v { Remote.getGlobal('appVersion') }</div>
        </div>
      </div>
    </div>
module.exports = connect(mapStateToProps, mapDispatchToProps) Footer

React = require 'react'

module.exports = React.createClass
    displayName: 'Debug'
    render: ->

        <span className='Debug'>{ @props.msg }</span>

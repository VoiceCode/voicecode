React = require 'react'
AppBar = require 'material-ui/lib/app-bar'
IconButton = require 'material-ui/lib/icon-button'
FlatButton = require 'material-ui/lib/flat-button'
NavigationClose = require 'material-ui/lib/svg-icons/navigation/close'
module.exports = React.createClass
    displayName: 'Header'
    render: ->
      <AppBar
        title="VoiceCode"
        iconElementLeft={<IconButton><NavigationClose /></IconButton>}
        iconElementRight={<FlatButton label="Save" />} />

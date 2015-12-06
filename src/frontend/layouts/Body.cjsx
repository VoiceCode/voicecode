# @ben, about 'key' prop: https://facebook.github.io/react/docs/multiple-components.html#dynamic-children

React = require 'react'
Command = require '../components/Command.cjsx'
List = require 'material-ui/lib/lists/list'
ListDivider = require 'material-ui/lib/lists/list-divider'
ListItem = require 'material-ui/lib/lists/list-item'
View = require 'react-flexbox'

getFormattedCommands = ->
  commands = remote.getGlobal('Commands').mapping
  commands = _.map commands, (command) ->
    command = _.pick command, [
      'id', 'spoken', 'description', 'packageId', 'enabled'
    ]
    command
  commands = _.groupBy commands, 'packageId'


module.exports = React.createClass
    displayName: 'CommandsView'
    updateCommands: ->
      @setState _.extend @state, commands: getFormattedCommands()
    componentDidMount: ->
      Events.on 'commandEnabled', (command) => @updateCommands()
      Events.on 'commandDisabled', (command) => @updateCommands()
    getInitialState: ->
      commands: getFormattedCommands()
    renderCommands: (commands) ->
      _.map commands, (c, index) =>
          <Command key={"#{c.id}-command"} command={c} />
    render: ->
      lists = _.map @state.commands, (commands, packageId) =>
        [
          <List key={ "#{packageId}-list" } subheader={ "Package: #{_.capitalize packageId}" }>
            { @renderCommands commands }
          </List>
          <ListDivider key={ "#{packageId}-divider" } />
        ]
      <View row>
        <View column width='30%' className='aside'>

        </View>
        <View column width='70%' className='body'>
            { lists }
        </View>
      </View>

# @ben, about 'key' prop: https://facebook.github.io/react/docs/multiple-components.html#dynamic-children

React = require 'react'
Command = require '../components/Command.cjsx'
List = require 'material-ui/lib/lists/list'
ListDivider = require 'material-ui/lib/lists/list-divider'
ListItem = require 'material-ui/lib/lists/list-item'

formattedCommands = ->
  commands = remote.getGlobal('Commands').mapping
  commands = _.map commands, (command) ->
    command = _.pick command, [
      'id', 'spoken', 'description', 'packageId', 'enabled'
    ]
    unless command.packageId?
      command.packageId = 'core'
    command
  commands = _.groupBy commands, 'packageId'

renderCommands = (commands) ->
  _.map commands, (c) ->
    <Command key={c.id} command={c} />

module.exports = React.createClass
    displayName: 'Body'
    getInitialState: ->
      commands: formattedCommands()
    render: ->
      console.log @state.commands
      lists = _.map @state.commands, (commands, packageId) ->
        [
          <List key={ "#{packageId}-list" } subheader={ "Package: #{_.capitalize packageId}" }>
            { renderCommands commands }
          </List>
          <ListDivider key={ "#{packageId}-divider" } />
        ]
      <div>
        <aside className='aside'>
          aside
        </aside>
        <section className='body'>
            { lists }
        </section>
      </div>

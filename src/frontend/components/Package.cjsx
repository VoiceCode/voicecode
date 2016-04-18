React = require 'react'
CommandList = require './CommandList.cjsx'
immutable = require 'immutable'
{Card, CardText, CardHeader, FlatButton, Avatar} = require 'material-ui'
Package = class Package extends React.Component
  render: ->
    {name, description} = @props
    <Card>
      <CardHeader
        title={ name }
        subtitle={ description }
        avatar={ <Avatar>{name[0].toUpperCase()}</Avatar> }
        actAsExpander={ true }
        showExpandableButton={ true }
      />
      <CardText expandable={ true } initiallyExpanded={ false }>
        <CommandList commands={ @props.commands } />
      </CardText>
    </Card>

module.exports = Package

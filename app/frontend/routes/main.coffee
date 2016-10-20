React = require 'react'
{Route, IndexRoute} = require 'react-router'
Main = require '../containers/Main'
LogPage = require '../containers/LogPage'
CommandsPage = require '../containers/CommandsPage'
PackagesPage = require '../containers/PackagesPage'
SettingsPage = require '../containers/SettingsPage'

module.exports = (
  <Route path="/" component={Main}>
    <IndexRoute component={LogPage} />
    <Route path="/commands" component={CommandsPage} />
    <Route path="/packages" component={PackagesPage} />
    <Route path="/settings" component={SettingsPage} />
  </Route>
  )

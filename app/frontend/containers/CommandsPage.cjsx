React = require 'react'
PackageList = require '../components/PackageList'
CommandFilter = require '../components/CommandFilter'
classNames = require 'classnames'

class PackagesPage extends React.Component
  shouldComponentUpdate: -> false
  render: ->
    <div className='packagesPage'>
      <CommandFilter/>
      <PackageList viewMode='commands' />
    </div>

module.exports = PackagesPage

React = require 'react'
PackageList = require '../components/PackageList'
PackageFilter = require '../components/PackageFilter'
classNames = require 'classnames'

class PackagesPage extends React.Component
  shouldComponentUpdate: -> false
  render: ->
    <div className='packagesPage'>
      <PackageFilter/>
      <PackageList/>
    </div>

module.exports = PackagesPage

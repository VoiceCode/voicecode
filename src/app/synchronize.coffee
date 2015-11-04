class NatLinkSynchronizer
  constructor: ->
  synchronize: ->
    debug 'NatLinkSynchronizer'

class Synchronizer
  constructor: ->
    if platform is "darwin"
      @synchronizer = require '../lib/platforms/darwin/dragon/dragon_synchronizer'
    else if platform is "windows"
      @synchronizer = new NatLinkSynchronizer
  synchronize: ->
    @synchronizer.synchronize()

module.exports = new Synchronizer

class NatLinkSynchronizer
  constructor: ->
  synchronize: ->
    debug 'NatLinkSynchronizer'

class Synchronizer
  constructor: ->
    if platform is "darwin"
      return unless Settings.daragon_darwin.legacy
      _path = '../lib/platforms/darwin/dragon'
      @synchronizer = require "#{_path}/dragon_synchronizer"
    else if platform is "windows"
      @synchronizer = new NatLinkSynchronizer

    Events.on 'generateParserSuccess', ({parserChanged}) =>
      if parserChanged
        @synchronize
  synchronize: ->
    @synchronizer?.synchronize()

module.exports = new Synchronizer

class NatLinkSynchronizer
  constructor: ->
  synchronize: ->
    debug 'NatLinkSynchronizer'

class Synchronizer
  constructor: ->
    @synchronizer = switch platform
      when 'darwin'
        require "../lib/platforms/darwin/dragon/dragon_synchronizer"
      when 'windows'
        new NatLinkSynchronizer

    Events.on 'generateParserSuccess', ({parserChanged}) =>
      if parserChanged
        @synchronize()

  synchronize: ->
    @synchronizer.synchronize()

module.exports = new Synchronizer

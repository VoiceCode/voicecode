class @NatLinkSynchronizer
  constructor: ->
  synchronize: ->
    console.log "updating commands"

class @Synchronizer
  constructor: ->
    if platform is "darwin"
      @synchronizer = new DragonSynchronizer
    else if platform is "windows"
      @synchronizer = new NatLinkSynchronizer
  synchronize: ->
    @synchronizer.synchronize()

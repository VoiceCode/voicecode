

class @NatLinkSynchronizer
  constructor: ->
  synchronize: ->
    console.log "updating commands"

class @Synchronizer
  constructor: ->
    if platform is "darwin"
      switch Settings.dragonCommandsMode
        when 'new-school'
          @synchronizer = new DragonDictateSynchronizer.NewSchool()
        when 'old-school'
          @synchronizer = new DragonDictateSynchronizer.OldSchool()
    else if platform is "windows"
      @synchronizer = new NatLinkSynchronizer()
  synchronize: ->
    @synchronizer.synchronize()

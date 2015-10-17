@DragonDictateSynchronizer ?= {}
class @DragonDictateSynchronizer.NewSchool extends @DragonDictateSynchronizer.OldSchool
  constructor: ->
    super
    @lists = {}

  databaseFile: (extension) ->
    # file = [@home(), "Library/Application\ Support/Dragon/Commands/#{@getUsername()}.#{extension}"].join("/")
    file = [@home(), "Documents/Dragon/Commands/#{@getUsername()}.#{extension}"].join("/") # FOR DEVELOPMENT ONLY
    file

  deleteAllDynamic: ->
    @dynamicRun "DELETE FROM ZGENERALTERM"
    @dynamicRun "DELETE FROM ZSPECIFICTERM"

  deleteAllStatic: ->
    @run "DELETE FROM ZACTION"
    @run "DELETE FROM ZCOMMAND"
    @run "DELETE FROM ZTRIGGER"

  synchronize: ->
    # @deleteAllStatic()
    # @deleteAllDynamic()
    # @synchronizeStatic()
    # @synchronizeDynamic()

  createList: (name, items, bundle = '#') ->
    @dynamicRun "INSERT INTO ZGENERALTERM (Z_ENT, Z_OPT, ZBUNDLEIDENTIFIER, ZNAME, ZSPOKENLANGUAGE, ZTERMTYPE) VALUES (1, 1, $bundle, $name, $spokenLanguage, 'Alt')",
      $name: name
      $spokenLanguage: Settings.localeSettings[Settings.locale].dragonTriggerSpokenLanguage
      $bundle: bundle
    # get the new id
    result = @dynamicGet "SELECT * FROM ZGENERALTERM WHERE ZNAME = '#{name}' LIMIT 1"
    id = result?.Z_PK
    if @error
      console.error @error

    for item in items
      @createListItem item, id

  synchronizeListItems: ({name, listId, items, bundle}) ->
    for item in items
      @createListItem item, listId, bundle

  synchronizeStatic: () ->
    if @error
      console.log "error: dragon database not connected"
      return false
    needsCreating = []
    existing = @getJoinedCommands()
    for name in Commands.Utility.enabledCommandNames()
      chainedYesNo = [yes]
      if Settings.dragonVersion is 5
        chainedYesNo = [yes, no]
      # console.error name
      command = new DragonCommand(name, null)
      _.extend @lists, command.lists unless _.isEmpty command.lists
      continue unless command.needsDragonCommand()
      continue if Settings.dragonCommandsMode is 'new-school' and
      command.info.grammarType isnt 'dynamic'

      for chained in chainedYesNo
        dragonName = command.generateCommandName chained
        dragonBody = command.generateCommandBody chained
        scopes = command.getTriggerScopes()
        for scope in scopes
          bundle = @getBundleId(scope)
          continue if bundle is null and scope isnt "global"
          bundle = "global" if bundle is null
          needsCreating.push
            bundle: bundle
            triggerPhrase: dragonName
            body: dragonBody

    console.log "synchronizing commands"
    for item in needsCreating
      @createCommand item.bundle, item.triggerPhrase, item.body

  synchronizeDynamic: ->
    if @error
      console.log "error: dragon dynamic database not connected"
      return false
    # console.log @lists
    _.each @lists, (occurrences, variableName) =>
      _.each occurrences, (sublists, occurrence) =>
        _.each sublists, (listValues, sub) =>
          scopes = ["global"]
          for scope in scopes
            bundle = '#' if scope is 'global'
            @createList "#{variableName}oc#{occurrence}sub#{sub}", listValues, bundle

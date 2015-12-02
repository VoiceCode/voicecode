fs = require 'fs'
class DragonSynchronizer
  constructor: ->
    @sqlite3 = require("sqlite3").verbose()
    @bundles = {global: "global"}
    @lastId = (new Date()).getTime()
    @applicationVersions = {}
    @connectMain()
    @connectDynamic()
    @commands = {}
    @lists = {}
    @insertedLists = []
    @error = false

  connectMain: ->
    file = @databaseFile("ddictatecommands")
    exists = fs.existsSync(file)
    if exists
      @database = new @sqlite3.Database file, @sqlite3.OPEN_READWRITE, (err) =>
        if err?
          error 'aredragonSynchronizerError', err, "Could not connect to Dragon Dictate command database"
          @error = true
      @all = =>
        if @error
          error 'dragonSynchronizerError', @error, "Could not execute query"
          return
        args = _.toArray arguments
        asyncblock (flow) =>
          flow.firstArgIsError = false
          args.push flow.callback()
          flow.sync @database.all.bind(@database).apply null, args
      @get = =>
        if @error
          error 'dragonSynchronizerError', @error, "Could not execute query"
          return
        args = _.toArray arguments
        asyncblock (flow) =>
          flow.firstArgIsError = false
          args.push flow.callback()
          flow.sync @database.get.bind(@database).apply null, args
      @run = =>
        if @error
          error 'dragonSynchronizerError', @error, "Could not execute query"
          return
        args = _.toArray arguments
        asyncblock (flow) =>
          flow.firstArgIsError = false
          args.push flow.callback()
          flow.sync @database.run.bind(@database).apply null, args
    else
      error 'dragonSynchronizerError', file,
      "Dragon Dictate commands database was not found at: #{file}"
      @error = true

  connectDynamic: ->
    file = @databaseFile("ddictatedynamic")
    exists = fs.existsSync(file)
    if exists
      @dynamicDatabase = new @sqlite3.Database file, @sqlite3.OPEN_READWRITE, (err) =>
        if err?
          error 'dragonSynchronizerError', err, "Could not connect to Dragon Dictate dynamic database"
          @error = true
      @dynamicAll = =>
        if @error
          error 'dragonSynchronizerError', @error, "Could not execute query"
          return
        args = _.toArray arguments
        asyncblock (flow) =>
          flow.firstArgIsError = false
          args.push flow.callback()
          flow.sync @dynamicDatabase.all.bind(@dynamicDatabase).apply null, args
      @dynamicGet = =>
        if @error
          error 'dragonSynchronizerError', @error, "Could not execute query"
          return
        args = _.toArray arguments
        asyncblock (flow) =>
          flow.firstArgIsError = false
          args.push flow.callback()
          flow.sync @dynamicDatabase.get.bind(@dynamicDatabase).apply null, args
      @dynamicRun = =>
        if @error
          error 'dragonSynchronizerError', @error, "Could not execute query"
          return
        args = _.toArray arguments
        asyncblock (flow) =>
          flow.firstArgIsError = false
          args.push flow.callback()
          flow.sync @dynamicDatabase.run.bind(@dynamicDatabase).apply null, args
    else
      error 'dragonSynchronizerError', file,
      "Dragon Dictate dynamic commands database was not found at: #{file}"
      @error = true

  whoami: ->
    Execute("whoami")?.trim()

  getApplicationVersion: (bundle) ->
    return 0 if bundle is null # handling global
    if @applicationVersions[bundle]?
      @applicationVersions[bundle]
    else
      @get "SELECT * FROM ZCOMMAND WHERE ZAPPBUNDLE = '#{bundle}' LIMIT 1", (existing) =>
        found = if existing?.ZAPPVERSION?
          existing.ZAPPVERSION
        else
          SystemInfo.applicationMajorVersionFromBundle bundle
        @applicationVersions[bundle] = found
        found

  getUsername: ->
    if @username?
      @username
    else
      @username = @whoami()
      @username

  normalizeBundle: (bundle) ->
    if bundle is "global"
      null
    else
      bundle

  digest: (triggerPhrase, bundleId) ->
    CryptoJS.MD5([triggerPhrase, bundleId].join('')).toString()

  getJoinedCommands: ->
    @all """SELECT * FROM ZCOMMAND AS C
    LEFT OUTER JOIN ZACTION AS A ON A.Z_PK=C.Z_PK
    LEFT OUTER JOIN ZTRIGGER AS T ON T.Z_PK=C.Z_PK
    """
  createListItem: (name, listId) ->
    @dynamicRun "INSERT INTO ZSPECIFICTERM (Z_ENT, Z_OPT, ZNUMERICVALUE, ZGENERALTERM, ZNAME) VALUES (2, 1, 0, $listId, $name)",
      $name: name
      $listId: listId

  getNextRecordId: ->
    result = @get "SELECT * FROM ZTRIGGER ORDER BY Z_PK DESC LIMIT 1"
    (result?.Z_PK or 0) + 1
    # @get "SELECT last_insert_rowid() FROM ZTRIGGER"

  createCommandId: ->
    id = Date.now()
    # in case of collision
    if id is @lastId
      id = @lastId + 1
    @lastId = id
    id

  createCommand: (bundleId, triggerPhrase, body) ->
    locale = Settings.localeSettings[Settings.locale]
    commandId = @createCommandId()
    bundleId = null if bundleId is 'global'
    applicationVersion = if bundleId is "global"
      0
    else
      @getApplicationVersion bundleId

    id = @getNextRecordId()
    username = @getUsername()
    @run "BEGIN TRANSACTION;"
    @run "INSERT INTO ZTRIGGER (Z_ENT, Z_OPT, ZISUSER, ZCOMMAND, ZCURRENTCOMMAND, ZDESC, ZSPOKENLANGUAGE, ZSTRING) VALUES (4, 1, 1, #{id}, #{id}, 'voicecode', '#{locale.dragonTriggerSpokenLanguage}', $triggerPhrase);", {$triggerPhrase: triggerPhrase}
    @run "INSERT INTO ZACTION (Z_ENT, Z_OPT, ZISUSER, ZCOMMAND, ZCURRENTCOMMAND, ZOSLANGUAGE, ZTEXT) VALUES (1, 1, 1, #{id}, #{id}, '#{locale.dragonOsLanguage}', $body);", {$body: body}
    @run "INSERT INTO ZCOMMAND (Z_ENT, Z_OPT, ZACTIVE, ZAPPVERSION, ZCOMMANDID, ZDISPLAY, ZENGINEID, ZISCOMMAND,
    ZISCORRECTION, ZISDICTATION, ZISSLEEP, ZISSPELLING, ZVERSION, ZCURRENTACTION, ZCURRENTTRIGGER, ZLOCATION,
    ZAPPBUNDLE, ZOSLANGUAGE, ZSPOKENLANGUAGE, ZTYPE, ZVENDOR) VALUES (2, 4, 1, #{applicationVersion}, #{commandId},
    1, -1, 1, 0, 0, 0, 1, 1, #{id}, #{id}, NULL, $bundle, '#{locale.dragonOsLanguage}', '#{locale.dragonCommandSpokenLanguage}', 'ShellScript', $username);", {$bundle: @normalizeBundle(bundleId), $username: username}
    @run "UPDATE Z_PRIMARYKEY SET Z_MAX = #{id} WHERE Z_NAME = 'action'"
    @run "UPDATE Z_PRIMARYKEY SET Z_MAX = #{id} WHERE Z_NAME = 'trigger'"
    @run "UPDATE Z_PRIMARYKEY SET Z_MAX = #{id} WHERE Z_NAME = 'command'"
    @run "COMMIT TRANSACTION;"

  deleteCommand: (id) ->
    if id
      @run "BEGIN TRANSACTION;"
      @run "DELETE FROM ZCOMMAND WHERE Z_PK = #{id};"
      @run "DELETE FROM ZACTION WHERE Z_PK = #{id};"
      @run "DELETE FROM ZTRIGGER WHERE Z_PK = #{id};"
      @run "COMMIT TRANSACTION;"

  databaseFile: (extension) ->
    os = require 'os'
    home = os.homedir()
    # file = [home, "Library/Application\ Support/Dragon/Commands/#{@getUsername()}.#{extension}"].join("/")
    file = [home, "Documents/Dragon/Commands/#{@getUsername()}.#{extension}"].join("/") # FOR DEVELOPMENT ONLY
    file

  deleteAllDynamic: ->
    @dynamicRun "DELETE FROM ZGENERALTERM"
    @dynamicRun "DELETE FROM ZSPECIFICTERM"

  deleteAllStatic: ->
    @run "DELETE FROM ZACTION"
    @run "DELETE FROM ZCOMMAND"
    @run "DELETE FROM ZTRIGGER"

  synchronize: ->
    emit 'dragonSynchronizingStarted'
    if @error
      error 'dragonSynchronizerError', null, "Could not synchronize with Dragon Dictate database"
    else
      @deleteAllStatic()
      @deleteAllDynamic()
      @synchronizeStatic()
      @synchronizeDynamic()
    unless @error
      emit 'dragonSynchronizingEnded'

  createList: (name, items, bundle = '#') ->
    @dynamicRun "INSERT INTO ZGENERALTERM (Z_ENT, Z_OPT, ZBUNDLEIDENTIFIER, ZNAME, ZSPOKENLANGUAGE, ZTERMTYPE) VALUES (1, 1, $bundle, $name, $spokenLanguage, 'Alt')",
      $name: name
      $spokenLanguage: Settings.localeSettings[Settings.locale].dragonTriggerSpokenLanguage
      $bundle: bundle
    # get the new id
    result = @dynamicGet "SELECT * FROM ZGENERALTERM WHERE ZNAME = '#{name}' LIMIT 1"
    id = result?.Z_PK
    if @error
      error 'dragonSynchronizeDynamicError', null, "Dragon database not connected"
    @insertedLists.push "#{bundle}#{name}"
    for item in items
      @createListItem item, id

  synchronizeStatic: () ->
    if @error
      error 'dragonSynchronizeStaticError', null, "Dragon database not connected"
      return false
    needsCreating = []

    chainedYesNo = [yes]
    if Settings.dragonVersion is 5
      chainedYesNo = [yes, no]
    DragonCommand = require './dragon_command'
    for id in Commands.getEnabled()
      command = new DragonCommand(id, null)
      continue unless command.needsDragonCommand()
      @commands[id] = command
      @lists[id] = command.dragonLists if command.dragonLists?
      if Settings.dragonCommandMode is 'pure-vocab'
        continue if id isnt 'dragon.catch-all'
      # if Settings.dragonCommandMode is 'new-school'
      #   continue unless command.grammarType in ['custom', 'textCapture', 'oneArgument'] or
      #   command.kind is 'recognition'
      for hasChain in chainedYesNo
        # assume input always required for textCapture
        # exceptions will be handled by new school recognition command
        if Settings.dragonCommandMode is 'new-school' and
        command.grammarType is 'textCapture' and
        hasChain is no
          continue

        continue if id is 'dragon.catch-all' and hasChain is no
        dragonName = command.generateCommandName hasChain
        dragonBody = command.generateCommandBody hasChain
        bundleIds = command.getApplications()
        _.all bundleIds, (bundle) ->
          return unless Actions.checkBundleExistence(bundle)
          needsCreating.push
            bundle: bundle
            triggerPhrase: dragonName
            body: dragonBody

    for item in needsCreating
      @createCommand item.bundle, item.triggerPhrase, item.body

  synchronizeDynamic: ->
    if @error
      error 'dragonSynchronizeDynamicError', null, "Dragon database not connected"
      return false

    _.all @lists, (lists, commandName) =>
      _.all lists, (occurrences, variableName) =>
        _.all occurrences, (sublists, occurrence) =>
          _.all sublists, (listValues, sub) =>
            bundleIds = @commands[commandName].getApplications()
            _.all bundleIds, (bundle) ->
              return unless Actions.checkBundleExistence(bundle)
              bundle = '#' if bundle is 'global'
              unless "#{bundle}#{variableName}_#{occurrence}_#{sub}" in @insertedLists
                @createList "#{variableName}_#{occurrence}_#{sub}", listValues, bundle

module.exports = new DragonSynchronizer

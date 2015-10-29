class @DragonSynchronizer
  constructor: ->
    @sqlite3 = Meteor.npmRequire("sqlite3").verbose()
    @bundles = {global: "global"}
    @applicationNames = {}
    @lastId = (new Date()).getTime()
    @applicationVersions = {}
    @connectMain()
    @connectDynamic()
    @commands = {}
    @lists = {}
    @insertedLists = []
  connectMain: ->
    file = @databaseFile("ddictatecommands")
    exists = fs.existsSync(file)
    if exists
      @database = new @sqlite3.Database file, @sqlite3.OPEN_READWRITE, (error) =>
        if error
          console.log "Error: Could not connect to Dragon Dictate command database"
          @error = true
      @all = Meteor.wrapAsync(@database.all.bind(@database))
      @get = Meteor.wrapAsync(@database.get.bind(@database))
      @run = Meteor.wrapAsync(@database.run.bind(@database))
    else
      console.log "error: Dragon Dictate commands database was not found at: #{file}"
  connectDynamic: ->
    file = @databaseFile("ddictatedynamic")
    exists = fs.existsSync(file)
    if exists
      @dynamicDatabase = new @sqlite3.Database file, @sqlite3.OPEN_READWRITE, (error) =>
        if error
          console.log "Error: Could not connect to Dragon Dictate dynamic command database"
          @error = true
      @dynamicAll = Meteor.wrapAsync(@dynamicDatabase.all.bind(@dynamicDatabase))
      @dynamicGet = Meteor.wrapAsync(@dynamicDatabase.get.bind(@dynamicDatabase))
      @dynamicRun = Meteor.wrapAsync(@dynamicDatabase.run.bind(@dynamicDatabase))
    else
      console.log "error: Dragon Dictate dynamic commands database was not found at: #{file}"
  home: ->
    process.env.HOME or process.env.USERPROFILE or "/Users/#{@whoami}"
  whoami: ->
    # Execute("whoami")?.trim()
    path = process.env.HOME?.split('/')
    path[path.length - 1]
  getBundleId: (name) ->
    if @bundles[name]
      @bundles[name]
    else
      bundle = Applescript("""
      try
        return id of app \"#{name}\"
      on error errMsg number errNum
        return ""
      end try
      """)?.trim()
      if bundle? and bundle.replace(/[^\w]/g, '').length
        @bundles[name] = bundle
        @applicationNames[bundle] = name
        bundle
      else
        @bundles[name] = null # catching empty so we don't retry
        @applicationNames[bundle] = name
        # console.log "could not get bundle identifier for: #{name}"
        null
  getApplicationVersion: (bundle) ->
    return 0 if bundle is null # handling global
    name = @applicationNames[bundle]
    if @applicationVersions[name]?
      @applicationVersions[name]
    else
      existing = @get "SELECT * FROM ZCOMMAND WHERE ZAPPBUNDLE = '#{bundle}' LIMIT 1"
      found = if existing?.ZAPPVERSION?
        existing.ZAPPVERSION
      else
        version = Applescript("version of application \"#{name}\"")?.trim()
        if version?
          first = version.toString().split('')[0]
          number = parseInt first
          if isNaN(number)
            0
          else
            number
        else
          0
      @applicationVersions[name] = found
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
    file = [@home(), "Library/Application\ Support/Dragon/Commands/#{@getUsername()}.#{extension}"].join("/")
    # file = [@home(), "Documents/Dragon/Commands/#{@getUsername()}.#{extension}"].join("/") # FOR DEVELOPMENT ONLY
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
    @deleteAllStatic()
    @deleteAllDynamic()
    @synchronizeStatic()
    @synchronizeDynamic()
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
      console.error '-'
      console.error @error
    @insertedLists.push "#{bundle}#{name}"
    for item in items
      @createListItem item, id

  synchronizeStatic: () ->
    if @error
      console.log "error: dragon database not connected"
      return false
    needsCreating = []

    chainedYesNo = [yes]
    if Settings.dragonVersion is 5
      chainedYesNo = [yes, no]

    for name in Commands.Utility.enabledCommandNames()
      # console.error name
      command = new DragonCommand(name, null)
      continue unless command.needsDragonCommand()
      @commands[name] = command
      @lists[name] = command.dragonLists if command.dragonLists?
      if Settings.dragonCommandMode is 'pure-vocab'
        continue if name isnt 'vc-catch-all'
      if Settings.dragonCommandMode is 'new-school'
        continue unless command.grammarType in ['custom', 'textCapture', 'oneArgument'] or
        command.kind is 'recognition'
      for hasChain in chainedYesNo
        # assume input always required for textCapture
        # exceptions will be handled by new school recognition command
        if Settings.dragonCommandMode is 'new-school' and
        command.grammarType is 'textCapture' and
        hasChain is no
          continue

        continue if name is 'vc-catch-all' and hasChain is no
        dragonName = command.generateCommandName hasChain
        dragonBody = command.generateCommandBody hasChain
        scopes = command.getTriggerScopes()
        for scope in scopes
          bundle = 'global'
          bundle = @getBundleId(scope) if scope isnt 'global'
          continue if bundle is null
          needsCreating.push
            bundle: bundle
            triggerPhrase: dragonName
            body: dragonBody

    for item in needsCreating
      @createCommand item.bundle, item.triggerPhrase, item.body

  synchronizeDynamic: ->
    if @error
      console.log "error: dragon dynamic database not connected"
      return false

    _.each @lists, (lists, commandName) =>
      _.each lists, (occurrences, variableName) =>
        _.each occurrences, (sublists, occurrence) =>
          _.each sublists, (listValues, sub) =>
            scopes = @commands[commandName].getTriggerScopes()
            for scope in scopes
              bundle = @getBundleId(scope) if scope isnt 'global'
              continue if bundle is null and scope isnt "global"
              bundle = '#' if scope is 'global'
              unless "#{bundle}#{variableName}_#{occurrence}_#{sub}" in @insertedLists
                @createList "#{variableName}_#{occurrence}_#{sub}", listValues, bundle

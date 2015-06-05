fs = Meteor.npmRequire('fs')
sqlite3 = Meteor.npmRequire("sqlite3").verbose()

class @Synchronizer
  constructor: (@database) ->
    @bundles = {global: "global"}
    @applicationNames = {}
    @lastId = (new Date()).getTime()
    @applicationVersions = {}
    file = @databaseFile()
    exists = fs.existsSync(file)
    if exists
      @database = new sqlite3.Database file, sqlite3.OPEN_READWRITE, (error) =>
        if error
          console.log "Error: Could not connect to Dragon Dictate command database"
          @error = true
      @all = Meteor.wrapAsync(@database.all.bind(@database))
      @get = Meteor.wrapAsync(@database.get.bind(@database))
      @run = Meteor.wrapAsync(@database.run.bind(@database))
    else
      console.log "error: Dragon Dictate commands database was not found at: #{file}"
  home: ->
    process.env.HOME or process.env.USERPROFILE or "/Users/#{@whoami}"
  whoami: ->
    # Execute("whoami")?.trim()
    path = process.env.HOME?.split('/')
    path[path.length - 1]
  databaseFile: ->
    file = [@home(), "Library/Application\ Support/Dragon/Commands/#{@getUsername()}.ddictatecommands"].join("/")
    console.log file
    file
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
      if bundle?.length
        @bundles[name] = bundle
        @applicationNames[bundle] = name
        bundle
      else
        console.log "could not get bundle identifier for: #{name}"
  getApplicationVersion: (bundle) ->
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
  getAllCommands: ->
    @all "SELECT * FROM ZCOMMAND"
  getAllTriggers: ->
    @all "SELECT * FROM ZTRIGGER"
  getAllActions: ->
    @all "SELECT * FROM ZACTION"
  getJoinedCommands: ->
    @all """SELECT * FROM ZCOMMAND AS C
    LEFT OUTER JOIN ZACTION AS A ON A.Z_PK=C.Z_PK
    LEFT OUTER JOIN ZTRIGGER AS T ON T.Z_PK=C.Z_PK
    """
  updateAllCommands: (perform=false) ->
    if @error
      console.log "error: dragon database not connected"
      return false
    results = {}
    existing = @getJoinedCommands()
    for item in existing
      trigger = item.ZSTRING?.trim()
      if trigger and trigger.indexOf("/!Text!/") >= 0
        bundle = (item.ZAPPBUNDLE or "global").trim()
        results[bundle] ||= {}
        results[bundle][trigger] = item

    needsCreating = []
    needsUpdating = []
    needsDeleting = []

    for name in Commands.Utility.enabledCommandNames()
      command = new Commands.Base(name, null)
      dragonName = command.generateDragonCommandName()
      body = command.generateDragonBody().trim()
      for scope in command.getTriggerScopes()
        bundle = @getBundleId(scope)
        if bundle?.length
          value = results[bundle]?[dragonName]
          if value?
            if value.ZTEXT?.trim() is body
              # everything is fine, command is good
            else
              # command body needs updating
              needsUpdating.push
                id: value.Z_PK
                body: body
                bundle: bundle
          else if command.needsDragonCommand()
            # command is missing
            needsCreating.push
              bundle: bundle
              triggerPhrase: dragonName
              body: body
          else
            # command doesn't need to exist in dragon

          if results[bundle]?[dragonName]?
            delete results[bundle][dragonName]

    # leftovers
    for bundle, items of results
      for trigger, content of items
        needsDeleting.push
          id: content.Z_PK
          trigger: trigger
          bundle: bundle

    final =
      needsCreating: needsCreating
      needsUpdating: needsUpdating
      needsDeleting: needsDeleting

    console.log final

    if perform
      console.log "synchronizing commands"
      for item in needsCreating
        @createCommand item.bundle, item.triggerPhrase, item.body
      for item in needsUpdating
        @updateAction item.id, item.body
      for item in needsDeleting
        @deleteCommand item.id

    final
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
    applicationVersion = if bundleId is "global"
      0
    else
     @getApplicationVersion bundleId

    id = @getNextRecordId()
    username = @getUsername()
    @run "BEGIN TRANSACTION;"
    @run "INSERT INTO ZTRIGGER (Z_ENT, Z_OPT, ZISUSER, ZCOMMAND, ZCURRENTCOMMAND, ZDESC, ZSPOKENLANGUAGE, ZSTRING) VALUES (4, 1, 1, #{id}, #{id}, 'command description', '#{locale.dragonTriggerSpokenLanguage}', $triggerPhrase);", {$triggerPhrase: triggerPhrase}
    @run "INSERT INTO ZACTION (Z_ENT, Z_OPT, ZISUSER, ZCOMMAND, ZCURRENTCOMMAND, ZOSLANGUAGE, ZTEXT) VALUES (1, 1, 1, #{id}, #{id}, '#{locale.dragonOsLanguage}', $body);", {$body: body}
    @run "INSERT INTO ZCOMMAND (Z_ENT, Z_OPT, ZACTIVE, ZAPPVERSION, ZCOMMANDID, ZDISPLAY, ZENGINEID, ZISCOMMAND,
    ZISCORRECTION, ZISDICTATION, ZISSLEEP, ZISSPELLING, ZVERSION, ZCURRENTACTION, ZCURRENTTRIGGER, ZLOCATION,
    ZAPPBUNDLE, ZOSLANGUAGE, ZSPOKENLANGUAGE, ZTYPE, ZVENDOR) VALUES (2, 4, 1, #{applicationVersion}, '#{commandId}',
    1, -1, 1, 0, 0, 0, 1, 1, #{id}, #{id}, NULL, $bundle, '#{locale.dragonOsLanguage}', '#{locale.dragonCommandSpokenLanguage}', 'ShellScript', $username);", {$bundle: @normalizeBundle(bundleId), $username: username}
    @run "UPDATE Z_PRIMARYKEY SET Z_MAX = #{id} WHERE Z_NAME = 'action'"
    @run "UPDATE Z_PRIMARYKEY SET Z_MAX = #{id} WHERE Z_NAME = 'trigger'"
    @run "UPDATE Z_PRIMARYKEY SET Z_MAX = #{id} WHERE Z_NAME = 'command'"
    @run "COMMIT TRANSACTION;"
  updateAction: (id, body) ->
    @run "UPDATE ZACTION SET ZTEXT = $body WHERE Z_PK = #{id};", {$body: body}
  deleteCommand: (id) ->
    if id
      @run "BEGIN TRANSACTION;"
      @run "DELETE FROM ZCOMMAND WHERE Z_PK = #{id};"
      @run "DELETE FROM ZACTION WHERE Z_PK = #{id};"
      @run "DELETE FROM ZTRIGGER WHERE Z_PK = #{id};"
      @run "COMMIT TRANSACTION;"

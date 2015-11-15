# console.log = require 'nslog'
path = require 'path'
notifier = require 'node-notifier'
class EventEmitter extends require('events').EventEmitter
  instance = null
  constructor: ->
    return instance if instance?
    instance = @
    @debug = false
    @suppressedDebugEntries = [
      'commandEnabled'
      'commandDisabled'
      # 'commandNameChanged'
      'commandNotFound'
      'commandAfterAdded'
      'commandBeforeAdded'
      'commandMisspellingsAdded'
      'commandOverwritten'
      'dragonSynchronizingStarted'
      'dragonSynchronizingEnded'
      'writingFile'
      'chainParsed'
      'chainPreprocessed'
      'slaveCommandReceived'
      'masterConnected'
      'masterDisconnected'
      'assetEvaluation'
      'assetEvaluationError'
      'assetPath'
      'growlPhrase'
      'dragonPhrase'
      'slaveDisconnected'
      'slaveConnected'
    ]
    @suppressedDebugEntries = [
      # 'deprecation'
      'enableCommand'
      'commandCreated'
      'commandEnabled'
      # 'commandOverwritten'
      'commandAfterAdded'
      'commandBeforeAdded'
      'commandNameChanged'
      'commandMisspellingsAdded'
      'commandNameChanged'
      'userAssetEvent'
      'userAssetEvaluated'
      'commandValidationFailed'
      'commandValidationError'
    ]
  on: (event, callback) ->
    super

  error: (event) ->
    unless @debug
      namespace = event || 'VoiceCode'
      console.log chalk.white.bold.bgRed('  ERROR  '),
      chalk.white.bgBlack(" #{namespace}:"),
      chalk.white.bgBlack(_.toArray(arguments)[2] || _.toArray(arguments)[1])
    @emit.apply @, _.toArray arguments

  log: (event) ->
    unless @debug
      namespace = event || 'VoiceCode'
      console.log chalk.white.bold.bgBlue('   LOG   '),
      chalk.white.bgBlack(" #{namespace}:"),
      chalk.white.bgBlack(_.toArray(arguments)[2] || _.toArray(arguments)[1])
    @emit.apply @, _.toArray arguments

  warning: (event) ->
    unless @debug
      namespace = event || 'VoiceCode'
      console.log chalk.white.bold.bgYellow(' WARNING '),
      chalk.white.bgBlack(" #{namespace}:"),
      chalk.white.bgBlack(_.toArray(arguments)[2] || _.toArray(arguments)[1])
    @emit.apply @, _.toArray arguments

  notify: (event) ->
    unless @debug
      if Settings.notificationProvider is "Growl"
        # TODO: take user settings into consideration
        # https://github.com/mikaelbr/node-notifier
        namespace = event || 'VoiceCode'
        notifier.Growl().notify
          title: 'VoiceCode'
          message: _.toArray(arguments)[2]
          icon: path.join(projectRoot, 'assets', 'vc.png')
      @log.apply @, _.toArray arguments
    @emit.apply @, _.toArray arguments

  emit: (event) ->
    return unless event?
    if @debug
      unless event in @suppressedDebugEntries
        console.log "%s %s \n", chalk.white.bold.bgRed('   EVENT   '),
        chalk.black.bgWhite(" #{event} "),  _.toArray(arguments)[1..]
    super

Events = new EventEmitter
global.emit = _.bind Events.emit, Events
global.error = _.bind Events.error, Events
global.log = _.bind Events.log, Events
global.warning = _.bind Events.warning, Events
global.notify = _.bind Events.notify, Events
module.exports = Events

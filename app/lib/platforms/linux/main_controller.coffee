BaseController = require '../base/main_controller'

module.exports = new class MainLinuxController extends BaseController
  constructor: ->
    super
    Events.once 'startupComplete', => @listenAsSlave()

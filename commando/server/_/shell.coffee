@Shell = Meteor.npmRequire('shelljs')
@Execute = (script, options = null) ->
  options ?= {silent: true}
  Meteor.wrapAsync(Shell.exec, Shell)(script, options)

@Applescript = (script, options = null) ->
  Execute """osascript <<EOD
  #{script}
  EOD
  """, options

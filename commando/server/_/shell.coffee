@Shell = Meteor.npmRequire('shelljs')
@Execute = Meteor.wrapAsync(Shell.exec, Shell)

@Applescript = (script) ->
  Execute """osascript <<EOD
  #{script}
  EOD
  """

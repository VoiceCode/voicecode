@Shell = Meteor.npmRequire('shelljs')
@Execute = (script, options = null) ->
  options ?= {silent: true}
  try
    (Meteor.wrapAsync(Shell.exec, Shell))(script, options)
  catch error
    console.error 'CAUGHT: '
    console.error error
    console.error 'while executing: '
    console.error script
    console.error 'try passing {silent: false} as the second parameter to Execute'
    console.error 'in order to see script output'


@Applescript = (script, options = null) ->
  Execute """osascript <<EOD
  #{script}
  EOD
  """, options

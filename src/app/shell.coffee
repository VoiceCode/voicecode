Shell = require('shelljs')

Execute = (script, options = null) ->
  options ?= {}
  _.extend options, {silent: true}
  try
    result = Shell.exec(script, options)
    if result.code isnt 0
      throw Error "Command returned #{result.code}!"
    return result.output
  catch err
    error null, null, 'CAUGHT: '
    error null, null, err
    error null, null, 'WHILE EXECUTING: '
    error null, null, script

Applescript = (content, shouldReturn = true) ->
  script = $.NSAppleScript('alloc')('initWithSource', $(content)) # are we sure this gets garbage collected?
  results = script('executeAndReturnError', null)
  script('dealloc')
  if shouldReturn
    debug results
    results('stringValue')?.toString()
  else
    null



exports.Execute = Execute
exports.Applescript = Applescript

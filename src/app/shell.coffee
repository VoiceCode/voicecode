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
  script = $.NSAppleScript('alloc')('initWithSource', $(content))
  results = script('executeAndReturnError', null)
  returnValue = if shouldReturn and _.isFunction(results)
    debug results
    results('stringValue')?.toString()
  else
    null
  script('dealloc')
  returnValue



exports.Execute = Execute
exports.Applescript = Applescript

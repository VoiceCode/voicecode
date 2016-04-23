# Shell = require('shelljs')
cp = require('child_process')

Execute = (script, options = {}) ->
  try
    result = cp.execSync(script, options).toString('utf8')
    result
  catch err
    error null, null, 'CAUGHT: '
    error null, null, err
    error null, null, 'WHILE EXECUTING: '
    error null, null, script

Applescript = (content, shouldReturn = true) ->
  debug content
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

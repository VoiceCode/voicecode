# Shell = require('shelljs')
cp = require('child_process')

Execute = (script, options = {}, callback = null) ->
  if _.isFunction options
    callback = options
    options = {}
  method = 'execSync'
  if callback?
    method = 'exec'
  try
    result = cp[method](script, options, callback).toString('utf8')
    result
  catch err
    unless options.silent
      error null, null, err
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

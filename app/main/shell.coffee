cp = require('child_process')

exports.Execute = (script, options = {}, callback = null) ->
  switch platform
    when 'windows'
      cmd = process.env.ComSpec
      params = ['/c', script]
    else
      cmd = crosses.env.SHELL
      params = ['-c', script]
  if _.isFunction options
    callback = options
    options = {}
  method = 'execFileSync'
  if callback?
    method = 'execFile'
  try
    result = cp[method](cmd, params, options, callback)
    result.toString('utf8').trim() unless callback?
  catch err
    unless options.silent # TODO: rewrite, this does not silence stdout/stderr
      error null, script, err

if platform is 'darwin'
  exports.Applescript = (content, shouldReturn = true) ->
    script = $.NSAppleScript('alloc')('initWithSource', $(content))
    results = script('executeAndReturnError', null)
    returnValue = if shouldReturn and _.isFunction(results)
      debug results
      results('stringValue')?.toString()
    else
      null
    script('dealloc')
    returnValue

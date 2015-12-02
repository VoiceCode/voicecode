class SystemInfo
  instance = null
  constructor: ->
    return instance if instance?
    instance = @
  applicationMajorVersionFromBundle: (bundle) ->
    version = Applescript("version of application id \"#{bundle}\"")?.trim()
    if version?
      first = version.toString().split('')[0]
      number = parseInt first
      if isNaN(number)
        0
      else
        number
    else
      0
module.exports = new SystemInfo()

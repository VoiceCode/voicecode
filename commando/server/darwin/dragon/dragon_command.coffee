class @DragonCommand extends Command
  constructor: ->
    super

  generateCommandBody: (hasChain = false)->
    body = @getTriggerPhrase()
    if @isDynamicTriggerPhrase body
      body = body.replace /(\({2}|\(\/{2})(\w+)(\){2}|\/{2}\))/g, ->
        arg = _.toArray arguments
        variableName = arg[2].charAt(0).toUpperCase() + arg[2].slice(1)
        "${var#{variableName}} "
    body += " ${varText}" if hasChain
    body = body.replace /\s+/g, ' '
    body = body.replace /^\s/, ''
    body = body.replace /\s$/, ''
    """
    echo -e "#{body}" | nc -U /tmp/voicecode.sock
    """

  generateCommandName: (hasChain = false)->
    trigger = @getTriggerPhrase()
    trigger = "#{trigger} /!Text!/" if hasChain
    trigger = trigger.replace /\s+/g, ' '
    trigger = trigger.replace /^\s/, ''
    trigger = trigger.replace /\s$/, ''
    return trigger

  getDynamicTriggerPhrase: ->
    trigger = @info.triggerPhrase
    trigger = trigger.replace /\//g, ''
    trigger = trigger.replace /[(\|\/](\w*?\s)/g, -> arguments[0][...-1]
    trigger = trigger.replace /^\(([a-zA-Z/\s]+)\)\**/, '(($1))'
    trigger = trigger.replace /\(([a-zA-Z/\s]+)\)\*/g, '(//$1//)'
    trigger = trigger.replace /\(([a-zA-Z/\s]+)\)(?!\))/g, '(($1))'
    # console.error trigger
    _.each _.countBy(@getAllVariableNames(), (v) -> v), (count, variableName) =>
      _.each [1..count], (occurrence) =>
        # console.error "searching for: #{variableName}"
        numberOfSubs = _.size @lists[variableName][occurrence]
        expression = new RegExp "(#{variableName}[\/\/|\)\)])"
        nextOccurrence = expression.exec trigger
        # console.error nextOccurrence
        switch _.last nextOccurrence[0].split('')
          when ')'
            subs = _.reduce [1..numberOfSubs], (memo, sub) ->
              "#{memo} ((#{variableName}oc#{occurrence}sub#{sub}))"
            , ''
            trigger = trigger.replace "((#{variableName}))", subs
          else
            subs = _.reduce [1..numberOfSubs], (memo, sub) ->
              "#{memo} (//#{variableName}oc#{occurrence}sub#{sub}//)"
            , ''
            trigger = trigger.replace "(//#{variableName}//)", subs
    trigger.replace /\s+/g, ' '


  getTriggerScopes: ->
    @info.triggerScopes or [@info.triggerScope or "global"]

  needsDragonCommand: ->
    @info.needsDragonCommand != false


  # generateCommandBodyIfStatement: (varName, suffix)->
  #   varName = varName.charAt(0).toUpperCase() + varName.slice(1)
  #   """
  # if [ "$varHas#{varName}#{suffix}" == "1" ]
  # then
  # export var#{varName}#{suffix}=" ${var#{varName}#{suffix}}"
  # fi
  #   """

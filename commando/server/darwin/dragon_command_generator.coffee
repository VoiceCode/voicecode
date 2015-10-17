class @DragonCommand extends Command
  constructor: ->
    super
    @lists = {}
    @variableNames = {}
    if @isDynamicTriggerPhrase()
      @variableNames = @parseVariableNames()
      @lists = @generateLists()

  generateCommandBody: (hasChain = false)->
    body = @getTriggerPhrase()
    if @isDynamicTriggerPhrase body
      body = body.replace /(\(\(|\(\/{2})(\w+)(\){2}|\/{2}\))/g, ->
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

  getTriggerPhrase: ->
    triggerPhrase = @info.namespace or @namespace
    if @info.triggerPhrase?
      triggerPhrase = @info.triggerPhrase
    if @isDynamicTriggerPhrase()
      triggerPhrase = @getDynamicTriggerPhrase()
    triggerPhrase

  isDynamicTriggerPhrase: ->
    triggerPhrase = @info.namespace or @namespace
    if @info.triggerPhrase?
      triggerPhrase = @info.triggerPhrase
    triggerPhrase.match(/\(/)?

  getDynamicTriggerPhrase: ->
    trigger = @info.triggerPhrase
    trigger = trigger.replace /^\(([a-zA-Z]+)\)\**/, '(($1))'
    trigger = trigger.replace /\(([a-zA-Z]+)\)\*/g, '(//$1//)'
    trigger = trigger.replace /\(([a-zA-Z]+)\)(?!\))/g, '(($1))'
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

  # TODO: take order of occurrence into account?
  parseVariableNames: ->
    return [] unless @info.triggerPhrase?
    mandatory = @info.triggerPhrase.match(/\([a-zA-Z]+\)\*/g)
    optional = @info.triggerPhrase.match(/\([a-zA-Z]+\)(?!\*)/g)
    return [] unless mandatory? or optional? 
    variables = {}
    variables.mandatory = _.map mandatory, (v) -> v.replace /[\(\)]/g, ''
    variables.optional = _.map optional, (v) -> v.replace /[\(\)\*]/g, ''
    return variables

  getAllVariableNames: ->
    return [] unless @info.triggerPhrase?
    variables = @info.triggerPhrase.match(/\([a-zA-Z]+\)/g)
    return [] unless variables?
    variables = _.map variables, (v) -> v.replace /[\(\)]/g, ''
    return variables

  getVariableValuesFor: (variableName)->
    return [variableName] unless @info.variables?[variableName]?
    _.flatten _.map @info.variables[variableName].mapping, (values) -> values

  generateLists: ->
    variableNames = @getAllVariableNames()
    occurrenceCount = _.countBy(variableNames, (v) -> v)
    variableValues = {}
    # counting occurrences and generating a list of values
    _.each _.unique(variableNames), (variableName) =>
      variableValues[variableName] = @getVariableValuesFor variableName

    # console.error occurrenceCount
    # console.error variableNames
    # console.error variableValues
    lists = {}
    maximumTokenCount = {}
    _.each _.unique(variableNames), (variableName) ->
      lists[variableName] ?= {}
      maximumTokenCount[variableName] ?= []
      # breaking up each value into tokens and counting how many sublists
      # this list will need to be split into
      variableValues[variableName] = _.map variableValues[variableName], (value, index) ->
        value = value.split ' '
        if maximumTokenCount[variableName] < value.length
          maximumTokenCount[variableName] = value.length
        value
    # console.error variableValues
    maximumTokenCount
    # console.error maximumTokenCount

    _.each _.unique(variableNames), (variableName) ->
      _.each [1..occurrenceCount[variableName]], (occurrence) ->
        lists[variableName][occurrence] ?= {}
        _.each [1..maximumTokenCount[variableName]], (sublistIndex) ->
          lists[variableName][occurrence][sublistIndex] =
          _.compact(_.map variableValues[variableName], (tokens) -> tokens[(sublistIndex-1)] || null)
    # console.error lists
    lists













  # generateCommandBodyIfStatement: (varName, suffix)->
  #   varName = varName.charAt(0).toUpperCase() + varName.slice(1)
  #   """
  # if [ "$varHas#{varName}#{suffix}" == "1" ]
  # then
  # export var#{varName}#{suffix}=" ${var#{varName}#{suffix}}"
  # fi
  #   """

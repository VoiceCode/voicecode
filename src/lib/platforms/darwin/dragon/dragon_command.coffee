class DragonCommand extends Command
  constructor: ->
    super
    @dragonLists = null
    if @rule?
      @dragonLists = @generateDragonLists()

  generateCommandBody: (hasChain = false)->
    body = @getTriggerPhrase()
    if @rule?
      body = @generateCustomCommandName()
      body = body.replace /(\({2}|\(\/{2})(.+?)(\){2}|\/{2}\))/g, ->
        arg = _.toArray arguments
        variableName = arg[2].charAt(0).toUpperCase() + arg[2].slice(1).toLowerCase()
        "${var#{variableName}} "
    body += " ${varText}" if hasChain
    body = body.replace /\s+/g, ' '
    body = body.replace /_/g, ''
    body = body.replace /^\s/, ''
    body = body.replace /\s$/, ''
    """
    echo -e "#{body}" | nc -U /tmp/voicecode.sock
    """

  generateCommandName: (hasChain = false)->
    trigger = @getTriggerPhrase()
    
    if @rule?
      trigger = @generateCustomCommandName hasChain
    trigger = "#{trigger} /!Text!/" if hasChain
    unless trigger?
      debug @
    trigger = trigger.replace /\s+/g, ' '
    trigger = trigger.replace /^\s/, ''
    trigger = trigger.replace /\s$/, ''
    trigger

  generateCustomCommandName: ->
    trigger = @rule
    if @grammar.includeName?
      trigger = trigger.replace /<spoken>/, @getTriggerPhrase()
    trigger = trigger.replace /[(/](\w*?\s)/g, -> arguments[0][...-1]
    trigger = trigger.replace /\//g, ''
    # console.error trigger
    _.each _.countBy((_.compact(_.pluck @grammar.tokens, 'name')), (v) -> v), (count, variableName) =>
      _.each [1..count], (occurrence) =>
        # console.error "searching for: #{variableName}"
        numberOfSubs = _.size @dragonLists[variableName][occurrence]
        expression = new RegExp "\\(#{variableName}\\)\\*?"
        nextOccurrence = expression.exec trigger
        optional = if _.last(nextOccurrence[0].split('')) is '*'
          true
        else
          false
        subs = _.reduce [1..numberOfSubs], (memo, sub, currentSub) ->
          if optional or currentSub > 0
            "#{memo} (//#{variableName}_#{occurrence}_#{sub}//)"
          else
            "#{memo} ((#{variableName}_#{occurrence}_#{sub}))"
        , ''
        trigger = trigger.replace '('+variableName+')', subs
    trigger = trigger.replace /\*+/g, ''
    # console.error trigger
    trigger

  getTriggerScopes: ->
    @triggerScopes or [@triggerScope or "global"]

  needsDragonCommand: ->
    @needsCommand != false

  generateDragonLists: ->
    variableNames = _.compact _.pluck @grammar.tokens, 'name'
    occurrenceCount = _.countBy(variableNames, (v) -> v)
    variableValues = {}
    _.each _.unique(variableNames), (variableName) =>
      variableValues[variableName] = @grammar.lists[variableName].items
      unless _.isArray variableValues[variableName]
        variableValues[variableName] = _.keys variableValues[variableName]


    # console.error occurrenceCount
    # console.error variableNames
    # console.error variableValues
    lists = {}
    maximumTokenCount = {}
    _.each _.unique(variableNames), (variableName) ->
      lists[variableName] ?= {}
      maximumTokenCount[variableName] ?= 1
      # breaking up each value into tokens and counting how many sublists
      # this list will need to be split into
      variableValues[variableName] = _.map variableValues[variableName], (value, index) ->
        value = value.split ' '
        if maximumTokenCount[variableName] < value.length
          maximumTokenCount[variableName] = value.length
        value
    # console.error variableValues
    # console.error maximumTokenCount

    _.each _.unique(variableNames), (variableName) ->
      _.each [1..occurrenceCount[variableName]], (occurrence) ->
        lists[variableName][occurrence] ?= {}
        _.each [1..maximumTokenCount[variableName]], (sublistIndex) ->
          lists[variableName][occurrence][sublistIndex] =
          _.unique _.compact(_.map variableValues[variableName], (tokens) ->
            tokens[(sublistIndex-1)] || null)
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
module.exports = DragonCommand

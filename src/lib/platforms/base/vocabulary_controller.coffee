module.exports = class VocabularyController
  constructor: ->
    # lists of strings that should be added as vocab to boost accuracy
    @phrases =
      standard: []
      repeatable: []
      spaceBefore: []
      custom: []
      sequence: []
      # list of ["spoken", "written"] items, like
      # Commands.create
      #   triggerPhrase: "I.D.E controller"
      #   spoken: "ide controller"
      alternate: []

  prepareCommandVocabulary: ->
    for id, command of Commands.mapping
      if command.enabled is true
        unless command.vocabulary is false
          if command.rule?
            @addCustomCombinations id
          else
            if command.triggerPhrase?
              @phrases.alternate.push [command.spoken, command.triggerPhrase]
            else
              @phrases.standard.push command.spoken
          if command.repeatable
            @addRepeatableCombinations command.spoken
          else if command.spaceBefore
            space = Commands.get('symbols:space').spoken
            @phrases.spaceBefore.push [space, command.spoken].join(' ')

  prepareSettingsVocabulary: ->
    # standard vocabulary
    for item in Settings.vocabulary
      @phrases.standard.push item

    # vocab with alternate pronunciations
    for spoken, written of Settings.vocabularyAlternate
      @phrases.alternate.push [written, spoken]

  prepareSequenceVocabulary: ->
    for name, followers of Settings.commonSequences
      command = Commands.get name
      continue unless command? or command.enabled is false
      for suffix in followers
        suffix = Commands.get suffix
        continue unless suffix? or suffix.enabled is false
        # TODO 'spoken' needs to be more sophisticated here. Need to generalize it.
        # Could be a custom command or anything
        @phrases.sequence.push [command.spoken, suffix.spoken].join(' ')

  addCustomCombinations: (id) ->
    @phrases.custom = _.union @phrases.custom, new Command(id).grammar.speakableCombinations()

  addRepeatableCombinations: (spoken) ->
    @repetitions ?= _.keys Packages.get('repetition')?.settings()?.values
    for times in @repetitions
      @phrases.repeatable.push [spoken, times].join(' ')

  setup: ->
    @prepareCommandVocabulary()
    @prepareSettingsVocabulary()
    @prepareSequenceVocabulary()

  start: ->
    @setup()
    @generate()

    # TODO monitor other events and keep the generated files up to date
    # Event.on '???', =>
    #  @setup()
    #  @generate

    return @

  generate: ->
    error 'abstractMethodCalled', 'VocabularyController:generateVocabularies'

  generateVocabularyTraining: ->
    result = []
    for category, phrases of @phrases
      for phrase in phrases
        if _.isArray phrase
          # this means it is vocabulary alternate - so use the 'written' form. Not sure how to handle this
          result.push phrase[0]
        else
          result.push phrase
    result.join ' '

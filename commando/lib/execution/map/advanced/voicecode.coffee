Commands.create
  "creek":
    kind: "historic"
    grammarType: "numberCapture"
    description: "repeat last complete spoken phrase [n] times (default 1)"
    tags: ["repetition", "voicecode"]
    action: (context, input) ->
      previous = context.lastFullCommand
      if previous
        for i in [1..(input or 1)]
          _.each previous, (command) =>
            command.call(@)
  "wink":
    kind: "historic"
    grammarType: "individual"
    description: "repeat last individual command once"
    ignoreHistory: true
    tags: ["repetition", "voicecode"]
    action: (context, input) ->
      context.lastIndividualCommand.call(@)
  "chew":
    kind: "historic"
    grammarType: "individual"
    description: "repeat last individual command twice"
    ignoreHistory: true
    tags: ["repetition", "voicecode"]
    action: (context, input) ->
      times = if context.repetitionIndex is 0
        2
      else
        1
      for i in [1..times]
        context.lastIndividualCommand.call(@)
  "trace":
    kind: "historic"
    grammarType: "individual"
    description: "repeat last individual command 3 times"
    ignoreHistory: true
    tags: ["repetition", "voicecode"]
    action: (context, input) ->
      times = if context.repetitionIndex is 0
        3
      else
        2
      for i in [1..times]
        context.lastIndividualCommand.call(@)
  "quarr":
    kind: "historic"
    grammarType: "individual"
    description: "repeat last individual command 4 times"
    ignoreHistory: true
    tags: ["repetition", "voicecode"]
    action: (context, input) ->
      times = if context.repetitionIndex is 0
        4
      else
        3
      for i in [1..times]
        context.lastIndividualCommand.call(@)
  "fypes":
    kind: "historic"
    grammarType: "individual"
    description: "repeat last individual command 5 times"
    ignoreHistory: true
    tags: ["repetition", "voicecode"]
    action: (context, input) ->
      times = if context.repetitionIndex is 0
        5
      else
        4
      for i in [1..times]
        context.lastIndividualCommand.call(@)
  "repple":
    kind: "historic"
    grammarType: "numberCapture"
    description: "Repeats an individual command component. Right after any command say [repple X] to repeat it X times"
    tags: ["voicecode", "repetition"]
    ignoreHistory: true
    action: (context, input) ->
      times = parseInt(input)
      if times?
        times = if context.repetitionIndex is 0
          times or 1
        else
          (times or 1) - 1
        if times > 0 and times < (Settings.maximumRepetitionCount or 100)
          for i in [1..times]
            context.lastIndividualCommand.call(@)
  "recon":
    kind: "action"
    grammarType: "individual"
    description: "show previous commands in Alfred"
    tags: ["voicecode", "alfred"]
    action: ->
      @key " ", ['option']
      @string "vc "
  "flak":
    kind: "action"
    grammarType: "textCapture"
    description: "execute predefined voice script"
    tags: ["voicecode"]
    action: (input) ->
      if input?.length
        workflow = Scripts.fuzzyMatch Settings.workflows, input.join(' ')
        chain = new Commands.Chain(workflow + " ")
        results = chain.generateNestedInterpretation()
        _.each results, (command) =>
          command.call(@)
  "keeper":
    kind: "action"
    grammarType: "none" # treated specially in the grammar
    description: "whatever follows this command will be interpreted literally"
    tags: ["voicecode"]
    action: (input) ->
      if input?.length
        @string input.join(" ")
  "voicecode-mode":
    kind: "action"
    grammarType: "textCapture"
    description: "change voicecode command execution mode"
    tags: ["system", "voicecode"]
    triggerPhrase: "set mode"
    action: (input) ->
      if input?.length
        mode = Scripts.fuzzyMatch Settings.modes, input.join(' ')
        @setGlobalMode(mode)

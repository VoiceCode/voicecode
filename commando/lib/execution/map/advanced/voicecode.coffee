Commands.createDisabled
  "vc-catch-all":
    kind: "none"
    grammarType: "none"
    description: "catches all text - just for creation in Dragon"
    tags: ["voicecode", "recommended"]
    triggerPhrase: ""
    isSpoken: false
  "recon":
    description: "show previous commands in Alfred"
    tags: ["voicecode", "alfred"]
    action: ->
      @key " ", 'option'
      @string "vc "
  "flak":
    grammarType: "textCapture"
    description: "execute predefined voice script"
    tags: ["voicecode"]
    action: (input) ->
      if input?.length
        workflow = @fuzzyMatch Settings.workflows, input.join(' ')
        chain = new Commands.Chain(workflow + " ")
        results = chain.generateNestedInterpretation()
        _.each results, (command) =>
          command.call(@)
  "keeper":
    grammarType: "none" # treated specially in the grammar
    description: "whatever follows this command will be interpreted literally"
    tags: ["voicecode", "recommended"]
    action: (input) ->
      if input?.length
        @string input.join(" ")
  "set mode":
    grammarType: "textCapture"
    description: "change voicecode command execution mode"
    tags: ["system", "voicecode"]
    continuous: false
    action: (input) ->
      if input?.length
        mode = @fuzzyMatch Settings.modes, input.join(' ')
        @setGlobalMode(mode)
  "scratchy":
    description: "tries to do a 'smart' undo by deleting previously inserted characters if the previous command only inserted text"
    tags: ["system", "voicecode", "recommended"]
    action: () ->
      count = Commands.previousUndoByDeletingCount
      if count? and count > 0
        if @contextAllowsArrowKeyTextSelection()
          @repeat count, =>
            @key 'left', 'shift'
          @key "delete"
        else
          @repeat count, =>
            @key 'delete'
  "tragic":
    description: "tries to select the previously inserted text if possible"
    tags: ["system", "voicecode", "recommended"]
    action: () ->
      count = Commands.previousUndoByDeletingCount
      if count? and count > 0
        for i in [1..count]
          @key 'left', 'shift'
  "strict on":
    grammarType: "textCapture"
    description: "puts VoiceCode into one of the predefined 'strict' modes, where only a subset of commands can be executed"
    tags: ["voicecode", "recommended"]
    action: (input) ->
      mode = if input?
        @fuzzyMatchKey Settings.strictModes, input.join(' ')
      else
        "default"
      @enableStrictMode mode
  "strict off":
    grammarType: "textCapture"
    description: "puts VoiceCode into one of the predefined 'strict' modes, where only a subset of commands can be executed"
    tags: ["voicecode", "recommended"]
    action: (input) ->
      @disableStrictMode()


unless Settings.slaveMode
  invokeWith = 'createDisabled'
  invokeWith = 'create' if not _.isEmpty Settings.slaves
  Commands[invokeWith] "slaver",
    grammarType: "textCapture"
    kind: "action"
    continuous: false
    description: "Sets slave target if a parameter is given, otherwise returns to master"
    tags: ['voicecode']
    action: (input) ->
      slaveController.setTarget input
